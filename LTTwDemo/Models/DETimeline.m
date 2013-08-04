//
//  Timeline.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DETimeline.h"
#import "DETweet.h"
#import "DEUser.h"
#import "DEAPIRequest.h"
#import "DEAPIResponse.h"

@interface DETimeline ()
{
    NSMutableArray* _tweets;
    __weak DEUser* _user;
}
@end

@implementation DETimeline

// 標準のイニシャライザは無効に
// 外部からインスタンス化できない
-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _tweets = [aDecoder decodeObjectForKey:@"tweets"];
        _user = [aDecoder decodeObjectForKey:@"user"];
        _type = [aDecoder decodeIntegerForKey:@"type"];
        NSLog(@"decode %@, %@", self, _user);
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    [aCoder encodeObject:_tweets forKey:@"tweets"];
    [aCoder encodeConditionalObject:_user forKey:@"user"];
    [aCoder encodeInteger:_type forKey:@"type"];
}


- (instancetype)initWithType:(TimelineType)type user:(DEUser *)user
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

-(instancetype)initSearchTimelineWithQuery:(NSString *)query
{
    typeof(self) obj = [self initWithType:TimelineTypeSearch user:[DEUser me]];
    [obj setSearchQuery:query];
    return obj;
}


-(void)refreshWithCallback:(TimelineRefreshCallback)callback
{
    NSString* path;
    NSMutableDictionary* params = [(_tweets.count ? @{@"since_id": [[_tweets objectAtIndex:0] ID]} : @{}) mutableCopy];
    if (self.type == TimelineTypeHome) {
        path = @"/statuses/home_timeline";
    } else if (self.type == TimelineTypeUsers) {
        path = @"/statuses/user_timeline";
        params[@"user_id"] = self.user.ID;
    } else if (self.type == TimelineTypeSearch) {
        path = @"/search/tweets";
        params[@"q"] = self.query;
    } else {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid timeline type" userInfo:nil] raise];
    }
    
    DEAPIRequest* req = [[DEAPIRequest alloc] initWithAPI:path method:LTAPIRequestMethodGET params:params];
    [req sendRequestWithCallback:^(DEAPIResponse *response) {
        if (!response.success) {
            callback(NO, nil);
            return;
        }
        for (NSDictionary* dict in [response.statuses reverseObjectEnumerator]) {
            DETweet* tweet = [[DETweet alloc] initWithData:dict timeline:self];
            [_tweets insertObject:tweet atIndex:0];
        }
        callback(YES, [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [response.statuses count])]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [req params];
            NSLog(@"request will be deallocated");
        });
    }];
    
}

-(void)loadMoreWithCallback:(TimelineRefreshCallback)callback
{
    NSString* path;
    NSMutableDictionary* params = [(_tweets.count ? @{@"max_id": [[_tweets lastObject] ID]} : @{}) mutableCopy]; // 正しくは max_id は tweets最後のTweet id + 1
    if (self.type == TimelineTypeHome) {
        path = @"/statuses/home_timeline";
    } else if (self.type == TimelineTypeUsers) {
        path = @"/statuses/user_timeline";
        params[@"user_id"] = self.user.ID;
    } else if (self.type == TimelineTypeSearch) {
        path = @"/search/tweets";
        params[@"q"] = self.query;
    } else {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"invalid timeline type" userInfo:nil] raise];
    }
    
    DEAPIRequest* req = [[DEAPIRequest alloc] initWithAPI:path method:LTAPIRequestMethodGET params:params];
    [req sendRequestWithCallback:^(DEAPIResponse *response) {
        if (!response.success) {
            callback(NO, nil);
            return;
        }
        NSUInteger oldCount = _tweets.count;
        for (NSDictionary* dict in response.statuses) {
            DETweet* tweet = [[DETweet alloc] initWithData:dict timeline:self];
            [_tweets addObject:tweet];
        }
        callback(YES, [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(oldCount, [response.statuses count])]);
    }];
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, type:%d", [super description], self.type];
}


#pragma mark - Attributes


-(NSArray *)tweets
{
    return _tweets; // 本当はcopyのほうが良いが、パフォーマンスの都合で...
}

-(NSString *)localizedTitle
{
    if (self.type == TimelineTypeHome) {
        return [NSString stringWithFormat:@"Home Timeline (%@)", self.user.name];
    } else if (self.type == TimelineTypeUsers) {
        return [NSString stringWithFormat:@"%@'s Timeline", self.user.name];
    } else if (self.type == TimelineTypeSearch) {
        return [NSString stringWithFormat:@"Search %@", self.query];
    }
    return nil;
}

@end
