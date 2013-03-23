//
//  DEAPIRequest.m
//  DETodo
//
//  Created by ito on 2013/03/21.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEAPIRequest.h"
#import "DEAPIResponse.h"

#define DEBUG (1)

#if DEBUG
#warning DEBUG is Enabled
#endif

@implementation DEAPIRequest

-(NSURLRequest *)prepareRequest
{
    NSString* host = @"http://localhost:3000";
    NSString* url;
    if ([self.path hasPrefix:@"/auth"]) {
        url = [NSString stringWithFormat:@"%@%@", host, self.path];
    } else {
        url = [NSString stringWithFormat:@"%@/api%@", host, self.path];
    }
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    
    if (self.method == LTAPIRequestMethodPOST || self.method == LTAPIRequestMethodPUT) {
        if (self.params) {
            [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:self.params options:0 error:nil]];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        }
    }
    
    request.HTTPMethod = self.methodString;
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

-(void)sendRequestWithCallback:(DEAPIRequestCallback)callback
{
#if DEBUG
    // UIデバッグ用にリクエストを遅らせる場合
    // サーバー側でやったほうが良いかもしれない
    double delayInSeconds = 0.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [super sendRequestWithCallback:^(LTAPIResponse *res) {
            callback((id)res);
        }];
    });
#else
    [super sendRequestWithCallback:^(LTAPIResponse *res) {
        callback((id)res);
    }];
#endif
}

+(Class)APIResponseClass
{
    return [DEAPIResponse class];
}

@end
