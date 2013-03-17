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


// used by subclass
@property (nonatomic, readonly) NSHTTPURLResponse* HTTPResponse;
@property (nonatomic) NSData* responseData;
@property (nonatomic) NSURLResponse* response;
@property (nonatomic) NSError* error;
@property (nonatomic) LTAPIRequest* request;
- (void)showErrorAlert; // thread safe

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
- (NSError*)parseJSON; // if retuns nil, success

@end
