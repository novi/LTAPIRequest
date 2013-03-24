//
//  LTAPIResponse.h
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

@class LTAPIRequest;
@interface LTAPIResponse : NSObject

@property (nonatomic, readonly) BOOL success; // サブクラスでオーバーライド

@property (nonatomic, readonly, copy) id json;


// サブクラスから参照する (セット禁止)
@property (nonatomic, readonly) NSHTTPURLResponse* HTTPResponse;
@property (nonatomic) NSData* responseData;
@property (nonatomic) NSURLResponse* response;
@property (nonatomic) NSError* error;
@property (nonatomic) NSError* parseError;
@property (nonatomic) LTAPIRequest* request;

// APIリクエストのエラー時に呼ばれる
- (void)showErrorAlert; // リクエスト用の Queue で呼ばれるので注意

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
- (NSError*)parseJSON; // if retuns nil, success, JSONパース後何かしたい場合はオーバーライドする, パース用の Queue で呼ばれるので注意

@end
