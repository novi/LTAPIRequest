//
//  User.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "User.h"
#import "Timeline.h"
#import "APIRequest.h"
#import "APIResponse.h"

@interface User ()
{
    Timeline* _homeTimeline;
    Timeline* _usersTimeline;
}
@end

@implementation User


+(User *)me
{
    static User* me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[self alloc] initUser];
    });
    return me;
}

-(BOOL)isMe
{
    return [[[self class] me] isEqual:self];
}

// 標準のイニシャライザは無効に
-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

// 指定イニシャライザ
- (id)initUser
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(User *)userWithUserID:(NSString *)userID
{
    static NSMutableDictionary* dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = [NSMutableDictionary dictionary];
    });
    
    User* user = [dict objectForKey:userID];
    if (!user) {
        user = [[self alloc] initUser];
        [dict setObject:user forKey:userID];
    }
    return user;
}

#pragma mark - 

-(void)refreshUserInfoWithCallback:(LTModelGeneralCallback)callback
{
    NSString* screenName = self.account.username;
    
    APIRequest* req = [[APIRequest alloc] initWithAPI:@"/users/show" method:LTAPIRequestMethodGET params:self.ID ? @{@"user_id":self.ID} : @{@"screen_name":screenName} ];
    [req sendRequestWithCallback:^(APIResponse *response) {
        if (!response.success) {
            callback(NO);
            return;
        }
        [self replaceAttributesFromDictionary:response.json];
        callback(YES);
    }];
}


#pragma mark - Timelines

-(Timeline *)homeTimeline
{
    if (!self.isMe) {
        [[NSException exceptionWithName:NSGenericException reason:@"other users home timeline is not available." userInfo:nil] raise];
        return nil;
    }
    if (!_homeTimeline) {
        _homeTimeline = [[Timeline alloc] initWithType:TimelineTypeHome user:self];
    }
    return _homeTimeline;
}

-(Timeline *)usersTimeline
{
    if (!_usersTimeline) {
        _usersTimeline = [[Timeline alloc] initWithType:TimelineTypeUsers user:self];
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
