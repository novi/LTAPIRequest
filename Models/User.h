//
//  User.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTModel.h"

@class Timeline, ACAccount;
@interface User : LTModel

@property (nonatomic, readonly) Timeline* mainTimeline;
@property (nonatomic, readonly) Timeline* mentionTimeline;
@property (nonatomic, readonly, copy) NSString* screenName;
@property (nonatomic, readonly, copy) NSString* name;
@property (nonatomic, readonly, copy) NSString* profileImageURL;

+ (User*)me;

- (void)refreshUserInfoWithCallback:(LTModelGeneralCallback)callback;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
+ (User*)userWithUserID:(NSString*)userID;
@property (nonatomic) ACAccount* account;

@end
