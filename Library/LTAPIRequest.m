//
//  LTRequest.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTAPIRequest.h"
#import "LTAPIResponse.h"

#if LTAPIRequestDebug
#warning LTAPIRequestDebug is enabled
#define LTAPIRequestDebugLog NSLog
#else
#define LTAPIRequestDebugLog(...)  { do {} while (0);}
#endif

static int networkCount = 0;

@interface LTAPIRequest ()
{
}

@end

@implementation LTAPIRequest

-(id)initWithAPI:(NSString *)path method:(LTAPIRequestMethod)method params:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _path = [path copy];
        _method = method;
        _params = [dict copy];
    }
    return self;
}

-(void)sendRequestWithCallback:(LTAPIRequestCallback)callback
{
    NSURLRequest* request = [self prepareRequest];
    LTAPIRequestDebugLog(@"%@", [self descriptionWithRequest:request]);
    
    [[self class] beginNetworkConnection];
    [[self class] lt_sendAsynchronousRequest:request queue:[[self class] APIRequestQueue] completionHandler:^(NSURLResponse * urlResponse, NSData * responseData, NSError *error) {
        [[self class] endNetworkConnection];
        LTAPIResponse* res = [[[[self class] APIResponseClass] alloc] init];
        res.responseData = responseData;
        res.response = urlResponse;
        res.error = error;
        res.request = self;
        _response = res;
        if (!res.success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [res showErrorAlert];
                LTAPIRequestDebugLog(@"Request failed: %@", res);
                callback(res);
            });
            return;
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSError* error = [res parseJSON];
            if (error) {
                res.error = error;
                dispatch_async(dispatch_get_main_queue(), ^{
                    LTAPIRequestDebugLog(@"Parse Error: %@", res);
                    callback(res);
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    LTAPIRequestDebugLog(@"JSON: %@", res.json);
                    callback(res);
                });
            }
        });
    }];
}

+(Class)APIResponseClass
{
    [[NSException exceptionWithName:NSGenericException reason:@"shoud be overriden in subclass" userInfo:nil] raise];
    return Nil;
}

-(NSMutableURLRequest *)prepareRequest
{
    [[NSException exceptionWithName:NSGenericException reason:@"shoud be overriden in subclass" userInfo:nil] raise];
    return nil;
}

-(NSString *)descriptionWithRequest:(NSURLRequest*)request
{
    NSDictionary* methods = @{@(LTAPIRequestMethodPUT): @"PUT", @(LTAPIRequestMethodGET): @"GET",
                              @(LTAPIRequestMethodPOST): @"POST", @(LTAPIRequestMethodDELETE): @"DELETE"};
    return [NSString stringWithFormat:@"%@ %@ (%@)\n%@\n%@", methods[@(self.method)], self.path, self.params, request.allHTTPHeaderFields, request];
}

#pragma mark -

+(void)lt_sendAsynchronousRequest:(NSURLRequest *)request queue:(NSOperationQueue *)queue completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
    if ([NSThread mainThread] != [NSThread currentThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self lt_sendAsynchronousRequest:request queue:queue completionHandler:handler];
        });
        return;
    }

    [queue addOperationWithBlock:^{
        NSURLResponse* res = nil;
        NSError* error = nil;
        NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&res error:&error];
        handler(res, data, error);
    }];
}

+(NSOperationQueue *)imageRequestQueue
{
    static NSOperationQueue* queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 3;
    });
    return queue;
}

+(NSOperationQueue *)APIRequestQueue
{
    static NSOperationQueue* queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 1;
    });
    return queue;
}

+(void)beginNetworkConnection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        networkCount++;
        if (networkCount > 0) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        }
    });
}

+(void)endNetworkConnection
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (networkCount > 0) {
            networkCount--;
            if (networkCount == 0) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            }
        }
    });
}

@end
