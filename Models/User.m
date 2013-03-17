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
    Timeline* _mainTimeline;
    Timeline* _mentionTimeline;
}
@end

@implementation User


+(User *)me
{
    static User* me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[self alloc] init];
    });
    return me;
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
        user = [[self alloc] init];
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

-(Timeline *)mainTimeline
{
    if (!_mainTimeline) {
        _mainTimeline = [[Timeline alloc] initWithType:TimelineTypeMain user:self];
    }
    return _mainTimeline;
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
