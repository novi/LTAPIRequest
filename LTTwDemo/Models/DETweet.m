//
//  Tweet.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DETweet.h"
#import "DEUser.h"

@interface DETweet ()
{
    __weak DETimeline* _timeline;
    __weak DEUser* _byUser;
}
@end

@implementation DETweet

// 標準のイニシャライザは無効に
// 外部からインスタンス化できない
-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(id)initWithData:(NSDictionary *)dict timeline:(DETimeline *)timeline
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

-(DEUser *)byUser
{
    if (!_byUser) {
        _byUser = [DEUser userWithUserID:[[self attributeForKey:@"user"] objectForKey:@"id_str"]];
        [_byUser mergeAttributesFromDictionary:[self attributeForKey:@"user"]];
    }
    return _byUser;
}

@end
