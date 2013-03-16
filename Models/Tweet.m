//
//  Tweet.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "Tweet.h"
#import "User.h"

@interface Tweet ()
{
    __weak Timeline* _timeline;
    __weak User* _byUser;
}
@end

@implementation Tweet

-(id)initWithData:(NSDictionary *)dict timeline:(Timeline *)timeline
{
    self = [super init];
    if (self) {
        _timeline = timeline;
        [self replaceAttributesFromDictionary:dict];
    }
    return self;
}

-(NSString *)ID
{
    return [self attributeForKey:@"id_str"];
}

#pragma mark - Attributes

-(NSString *)text
{
    return [[self attributeForKey:@"text"] copy];
}

-(User *)byUser
{
    if (!_byUser) {
        _byUser = [User userWithUserID:[[self attributeForKey:@"user"] objectForKey:@"id_str"]];
        [_byUser mergeAttributesFromDictionary:[self attributeForKey:@"user"]];
    }
    return _byUser;
}

@end
