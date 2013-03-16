//
//  LTRequest.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LTAPIRequestMethod) {
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

- (void)sendRequestWithCallback:(LTAPIRequestCallback)callback;
+ (Class)APIResponseClass;

- (NSMutableURLRequest*)prepareRequest;

+ (void)lt_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue*) queue completionHandler:(void (^)(NSURLResponse*, NSData*, NSError*)) handler;

+ (NSOperationQueue*)imageRequestQueue;
+ (NSOperationQueue*)APIRequestQueue;
+ (void)beginNetworkConnection;
+ (void)endNetworkConnection;

@end
