//
//  LTModel.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTModel.h"

@interface LTModel ()
{
    NSMutableDictionary* _data;
}
@end

@implementation LTModel

- (id)init
{
    self = [super init];
    if (self) {
        _data = [NSMutableDictionary dictionary];
    }
    return self;
}

-(NSString *)ID
{
    return [self attributeForKey:@"id"];
}

#pragma mark - Attributes management

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
        [[NSException exceptionWithName:NSGenericException reason:@"replaceAttributesFromDictionary: given dictionary is nil" userInfo:nil] raise];
        return;
    }
    _data = [dict mutableCopy];
}

-(void)mergeAttributesFromDictionary:(NSDictionary *)dict
{
    if (!dict) {
        [[NSException exceptionWithName:NSGenericException reason:@"mergeAttributesFromDictionary: given dictionary is nil" userInfo:nil] raise];
        return;
    }
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [_data setObject:obj forKey:key];
    }];
}

#pragma mark -

-(id)initWithID:(NSString *)ID
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

+(id)modelWithID:(NSString *)ID
{
    NSMutableDictionary* store = [self modelStoreForModelClass:[self class]];
    
    id model = [store objectForKey:ID];
    if (!model) {
        model = [[self alloc] initWithID:ID];
        [store setObject:model forKey:ID];
    }
    return model;
}

@end
