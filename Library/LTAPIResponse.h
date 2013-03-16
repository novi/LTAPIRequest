//
//  LTAPIResponse.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTAPIResponse : NSObject

@property (nonatomic, readonly) BOOL success;
@property (nonatomic, readonly, copy) id json;


// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
@property (nonatomic, readonly) NSHTTPURLResponse* HTTPResponse;
@property (nonatomic) NSData* responseData;
@property (nonatomic) NSURLResponse* response;
@property (nonatomic) NSError* error;

- (NSError*)parseJSON; // if retuns nil, success
- (void)showErrorAlert; // thread safe

@end
