//
//  LTAPIResponse.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LTAPIRequest;
@interface LTAPIResponse : NSObject

@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly, copy) id json;


// サブクラスから参照する (セット禁止)
@property (nonatomic, readonly) NSHTTPURLResponse* HTTPResponse;
@property (nonatomic) NSData* responseData;
@property (nonatomic) NSURLResponse* response;
@property (nonatomic) NSError* error;
@property (nonatomic) LTAPIRequest* request;

// APIリクエストのエラー時に呼ばれる
- (void)showErrorAlert; // thread safe に実装する

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
- (NSError*)parseJSON; // if retuns nil, success, JSONパース後何かしたい場合はオーバーライドする, パース用の Queue で呼ばれるので注意

@end
