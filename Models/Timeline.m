//
//  Timeline.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "Timeline.h"
#import "Tweet.h"
#import "User.h"
#import "APIRequest.h"
#import "APIResponse.h"

@interface Timeline ()
{
    NSMutableArray* _tweets;
    __weak User* _user;
}
@end

@implementation Timeline

- (id)initWithType:(TimelineType)type user:(User *)user
{
    self = [super init];
    if (self) {
        _type = type;
        _user = user;
        _tweets = [NSMutableArray array];
    }
    return self;
}

-(void)setSearchQuery:(NSString *)query
{
    _query = query;
}


-(void)refreshWithCallback:(TimelineRefreshCallback)callback
{
    NSString* path;
    NSMutableDictionary* params = [(_tweets.count ? @{@"since_id": [[_tweets objectAtIndex:0] ID]} : @{}) mutableCopy];
    if ([[User me] isEqual:_user]) {
        path = @"/statuses/home_timeline";
    } else {
        path = @"/statuses/user_timeline";
        params[@"user_id"] = _user.ID;
    }
    
    APIRequest* req = [[APIRequest alloc] initWithAPI:path method:LTAPIRequestMethodGET params:params];
    [req sendRequestWithCallback:^(APIResponse *response) {
        if (!response.success) {
            callback(NO, nil);
            return;
        }
        for (NSDictionary* dict in [response.json reverseObjectEnumerator]) {
            Tweet* tweet = [[Tweet alloc] initWithData:dict timeline:self];
            [_tweets insertObject:tweet atIndex:0];
        }
        callback(YES, [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [response.json count])]);
        
    }];
    
}

-(void)loadMoreWithCallback:(TimelineRefreshCallback)callback
{
    NSString* path;
    NSMutableDictionary* params = [(_tweets.count ? @{@"max_id": [[_tweets lastObject] ID]} : @{}) mutableCopy]; // 正しくは max_id は tweets最後のTweet id + 1
    if ([[User me] isEqual:_user]) {
        path = @"/statuses/home_timeline";
    } else {
        path = @"/statuses/user_timeline";
        params[@"user_id"] = _user.ID;
    }
    
    APIRequest* req = [[APIRequest alloc] initWithAPI:path method:LTAPIRequestMethodGET params:params];
    [req sendRequestWithCallback:^(APIResponse *response) {
        if (!response.success) {
            callback(NO, nil);
            return;
        }
        NSUInteger oldCount = _tweets.count;
        for (NSDictionary* dict in response.json) {
            Tweet* tweet = [[Tweet alloc] initWithData:dict timeline:self];
            [_tweets addObject:tweet];
        }
        callback(YES, [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(oldCount, [response.json count])]);
    }];
}

#pragma mark - Attributes


-(NSArray *)tweets
{
    return _tweets; // 本当はcopyのほうが良いが、パフォーマンスの都合で...
}

-(NSString *)localizedTitle
{
    if (self.type == TimelineTypeMain) {
        return [NSString stringWithFormat:@"Timeline %@", _user.name];
    } else if (self.type == TimelineTypeMentions) {
        return [NSString stringWithFormat:@"Mentions %@", _user.name];
    } else if (self.type == TimelineTypeMain) {
        return [NSString stringWithFormat:@"Search %@", self.query];
    }
    return nil;
}

@end
