//
//  LTAPIResponse.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTAPIResponse.h"

@implementation LTAPIResponse

-(NSError *)parseJSON
{
    NSError* error = nil;
    _json = (id)[NSJSONSerialization JSONObjectWithData:_responseData options:0 error:&error];
    return error;
}

-(NSHTTPURLResponse *)HTTPResponse
{
    if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
        return (id)self.response;
    }
    return nil;
}

-(BOOL)success
{
    [[NSException exceptionWithName:NSGenericException reason:@"success: should be implemented on subclass" userInfo:nil] raise];
    return NO;
}

-(void)showErrorAlert
{
    
}

-(NSString *)description
{
    return [NSString stringWithFormat:@"%d -> %@ (Error: %@, %@)", self.HTTPResponse.statusCode, self.responseData ? [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] : @"<No Response Data>", self.error.localizedDescription, self.error.localizedFailureReason];
}

@end
