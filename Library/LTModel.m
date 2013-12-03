//
//  LTModel.m
//  LTAPIRequest
//
//  Created by Yusuke Ito on 2013/03/16.
//  Copyright (c) 2013 Yusuke Ito. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "LTModel.h"

static NSString* const LTModelClassName = @"LTModel";


@interface LTModel ()
{
    NSMutableDictionary* _data;
}
@end

@implementation LTModel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _data = [NSMutableDictionary dictionaryWithDictionary:[aDecoder decodeObjectForKey:@"lt_data"]];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_data forKey:@"lt_data"];
}

#pragma mark -

- (instancetype)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString*)IDKey
{
    return @"id";
}

-(NSString *)ID
{
    return [[self attributeForKey:[self IDKey]] copy];
}

#pragma mark - Attributes management

-(NSDictionary *)attributes
{
    return [_data copy];
}

- (void)removeAllAttributes
{
    _data = [NSMutableDictionary dictionary];
}

-(void)setAttribute:(id)attr forKey:(NSString *)key
{
    [_data setObject:[attr copy] forKey:key];
}

-(void)removeAttributeForKey:(NSString *)key
{
    [_data removeObjectForKey:key];
}

-(id)attributeForKey:(NSString *)key
{
    return [_data objectForKey:key];
}

-(void)replaceAttributesFromDictionary:(NSDictionary *)dict
{
    if (!dict) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"replaceAttributesFromDictionary: given dictionary is nil" userInfo:nil] raise];
        return;
    }
    _data = [dict mutableCopy];
}

-(void)mergeAttributesFromDictionary:(NSDictionary *)dict
{
    if (!dict) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"mergeAttributesFromDictionary: given dictionary is nil" userInfo:nil] raise];
        return;
    }
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [_data setObject:obj forKey:[key copy]];
    }];
}

@end

@implementation LTModel(ModelStore)

-(instancetype)initWithID:(NSString *)ID
{
    [[NSException exceptionWithName:NSGenericException reason:@"initWithID: should be overidden on subclass" userInfo:nil] raise];
    return nil;
}

+ (NSMutableDictionary*)modelStoreForModelClass:(Class)class
{
    static NSMutableDictionary* allStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        allStore = [NSMutableDictionary dictionary];
    });
    
    NSString* key = NSStringFromClass(class);
    NSMutableDictionary* store = [allStore objectForKey:key];
    if (!store) {
        store = [NSMutableDictionary dictionary];
        [allStore setObject:store forKey:key];
    }
    return store;
}

+(instancetype)modelWithID:(NSString *)ID
{
    if (!ID) {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"modelWithID: given ID is nil" userInfo:nil] raise];
        return nil;
    }
    
    NSMutableDictionary* store = [self modelStoreForModelClass:[self class]];
    
    id model = [store objectForKey:ID];
    if (!model) {
        model = [[self alloc] initWithID:ID];
        [store setObject:model forKey:ID];
    }
    return model;
}

+ (void)encodeModelStore:(NSCoder*)aCoder
{
    if ([NSStringFromClass(self) isEqualToString:LTModelClassName]) {
        [[NSException exceptionWithName:NSGenericException reason:@"should be encoded with LTModel's subclass(your model)" userInfo:nil] raise];
        return;
    }
    NSString* key = [NSString stringWithFormat:@"lt_modelstore_for_%@", NSStringFromClass([self class])];
    
    [aCoder encodeObject:[self modelStoreForModelClass:[self class]] forKey:key];
}

+ (void)decodeModelStore:(NSCoder*)aDecoder
{
    if ([NSStringFromClass(self) isEqualToString:LTModelClassName]) {
        [[NSException exceptionWithName:NSGenericException reason:@"should be encoded with LTModel's subclass(your model)" userInfo:nil] raise];
        return;
    }
    
    NSString* key = [NSString stringWithFormat:@"lt_modelstore_for_%@", NSStringFromClass([self class])];
    
    NSDictionary* dict = [[aDecoder decodeObjectForKey:key] mutableCopy];
    if (dict) {
        NSMutableDictionary* store = [self modelStoreForModelClass:[self class]];
        [store removeAllObjects];
        [store setDictionary:dict];
    }
}

@end
