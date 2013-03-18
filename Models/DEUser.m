//
//  User.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEUser.h"
#import "DETimeline.h"
#import "DEAPIRequest.h"
#import "DEAPIResponse.h"

@interface DEUser ()
{
    DETimeline* _homeTimeline;
    DETimeline* _usersTimeline;
}
@end

@implementation DEUser


+(DEUser *)me
{
    static DEUser* me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[self alloc] initWithID:nil];
    });
    return me;
}

-(BOOL)isMe
{
    return [[[self class] me] isEqual:self];
}

// 標準のイニシャライザは無効に
// 外部からインスタンス化できない
-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

// 指定イニシャライザ, 同じ ID の User は同じインスタンスを使うためこれが呼ばれる
- (id)initWithID:(NSString *)ID
{
    self = [super init];
    if (self) {
        if (ID) {
            [self setAttribute:ID forKey:@"id_str"];
        }
    }
    return self;
}

+(DEUser *)userWithUserID:(NSString *)userID
{
    if ([[self me].ID isEqualToString:userID]) {
        return [self me];
    }
    return [self modelWithID:userID];
}

#pragma mark - 

-(void)refreshUserInfoWithCallback:(LTModelGeneralCallback)callback
{
    NSString* screenName = self.account.username;
    
    DEAPIRequest* req = [[DEAPIRequest alloc] initWithAPI:@"/users/show" method:LTAPIRequestMethodGET params:self.ID ? @{@"user_id":self.ID} : @{@"screen_name":screenName} ];
    [req sendRequestWithCallback:^(DEAPIResponse *response) {
        if (!response.success) {
            callback(NO);
            return;
        }
        [self replaceAttributesFromDictionary:response.json];
        callback(YES);
    }];
}


#pragma mark - Timelines

-(DETimeline *)homeTimeline
{
    // 自分のみ
    if (!self.isMe) {
        [[NSException exceptionWithName:NSGenericException reason:@"other users home timeline is not available." userInfo:nil] raise];
        return nil;
    }
    if (!_homeTimeline) {
        _homeTimeline = [[DETimeline alloc] initWithType:TimelineTypeHome user:self];
    }
    return _homeTimeline;
}

-(DETimeline *)usersTimeline
{
    if (!_usersTimeline) {
        _usersTimeline = [[DETimeline alloc] initWithType:TimelineTypeUsers user:self];
    }
    return _usersTimeline;
}

#pragma mark - Attributes

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@, %@: %@ / %@", [super description], self.ID, self.screenName, self.name];
}

-(NSString *)ID
{
    return [self attributeForKey:@"id_str"];
}

-(NSString *)screenName
{
    return [self attributeForKey:@"screen_name"];
}

-(NSString *)name
{
    return [self attributeForKey:@"name"];
}

-(NSString *)profileImageURL
{
    return [self attributeForKey:@"profile_image_url"];
}

@end
