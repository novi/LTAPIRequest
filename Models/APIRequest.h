//
//  Request.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTAPIRequest.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@class APIResponse, User;

typedef void(^RequestCallback)(APIResponse* response);
typedef void(^RequestUserImageCallback)(UIImage* image, NSString* imageURL);

@interface APIRequest : LTAPIRequest

// Callbackの型は `RequestCallback` なのでオーバーライド
- (void)sendRequestWithCallback:(RequestCallback)callback;

// 共通で使用する AccountStore
+ (ACAccountStore*)accountStore;

// アイコンダウンロードのためのユーティリティメソッド
+ (void)downloadUserImageWithURL:(NSString*)url callback:(RequestUserImageCallback)callback;


@end
