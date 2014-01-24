//
//  LTAPIRequest.h
//  LTAPIRequest
//
//  Created by Yusuke Ito on 2013/03/16.
//  Copyright (c) 2013 Yusuke Ito. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>

//#define LTAPIRequestDebug (1)

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

// イニシャライザ
- (id)initWithAPI:(NSString*)path method:(LTAPIRequestMethod)method params:(NSDictionary*)dict;
@property (nonatomic, readonly, copy) NSString* path;
@property (nonatomic, readonly) LTAPIRequestMethod method;
@property (nonatomic, readonly, copy) NSString* methodString; // LTAPIRequestMethodGET -> "GET"... 
@property (nonatomic, readonly, copy) NSDictionary* params;
@property (nonatomic, readonly, weak) LTAPIResponse* response;

// サブクラスでオーバーライドする
- (void)sendRequestWithCallback:(LTAPIRequestCallback)callback; // APIのリクエストを送信
+ (Class)APIResponseClass; // APIResponseのクラス
- (NSURLRequest*)prepareRequest; // 実際に送信するRequestを作成

// ユーティリティメソッド
// (handlerはqueueのスレッドで呼ばれる)
+ (void)lt_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue*) queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

+ (NSOperationQueue*)imageRequestQueue; // 画像ダウンロード用 Queue
+ (NSOperationQueue*)APIRequestQueue; // APIリクエスト用 Queue

+ (void)beginNetworkConnection; // ネットワークインジケータ制御
+ (void)endNetworkConnection;

@end
