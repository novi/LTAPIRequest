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

-(NSMutableDictionary *)dictionaryRepresentation
{
    return [[_data copy] mutableCopy];
}

-(void)restoreFromDictionaryRepresentation:(NSDictionary *)dict
{
    [self replaceAttributesFromDictionary:dict];
}

#pragma mark - Attributes management

- (void)removeAllAttributes
{
    _data = [NSMutableDictionary dictionary];
}

-(void)setAttribute:(id)attr forKey:(NSString *)key
{
    if (attr) {
        [_data setObject:[attr copy] forKey:key];
    } else {
        [_data removeObjectForKey:key];
    }
}

-(id)attributeForKey:(NSString *)key
{
    return [_data objectForKey:key];
}

-(void)replaceAttributesFromDictionary:(NSDictionary *)dict
{
    _data = [dict mutableCopy];
}

-(void)mergeAttributesFromDictionary:(NSDictionary *)dict
{
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [_data setObject:obj forKey:key];
    }];
}

@end
