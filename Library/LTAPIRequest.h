//
//  LTRequest.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LTAPIRequestDebug (1)

typedef NS_ENUM(NSUInteger, LTAPIRequestMethod) {
    LTAPIRequestMethodInvalid = 0,
    LTAPIRequestMethodGET = 1,
    LTAPIRequestMethodPOST,
    LTAPIRequestMethodDELETE,
    LTAPIRequestMethodPUT
};

@class LTAPIResponse;
typedef void(^LTAPIRequestCallback)(LTAPIResponse* res);

@interface LTAPIRequest : NSObject

- (id)initWithAPI:(NSString*)path method:(LTAPIRequestMethod)method params:(NSDictionary*)dict;
@property (nonatomic, readonly, copy) NSString* path;
@property (nonatomic, readonly) LTAPIRequestMethod method;
@property (nonatomic, readonly, copy) NSDictionary* params;
@property (nonatomic, readonly, weak) LTAPIResponse* response;

- (void)sendRequestWithCallback:(LTAPIRequestCallback)callback;
+ (Class)APIResponseClass;

- (NSMutableURLRequest*)prepareRequest;

// ユーティリティメソッド
// handlerはqueueのスレッドで呼ばれる
+ (void)lt_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue*) queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

+ (NSOperationQueue*)imageRequestQueue; // 画像ダウンロード用 Queue
+ (NSOperationQueue*)APIRequestQueue; // APIリクエスト用 Queue

+ (void)beginNetworkConnection; // ネットワークインジケータ制御
+ (void)endNetworkConnection;

@end
