//
//  APIResponse.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "APIResponse.h"
#import "APIRequest.h"

@implementation APIResponse

-(BOOL)success
{
    if (self.error || !self.responseData) {
        return NO;
    }
    if (self.HTTPResponse.statusCode >= 200 && self.HTTPResponse.statusCode < 300) {
        return YES;
    }
    return NO;
}

- (void)showErrorAlert
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.error) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:self.error.localizedDescription message:self.error.localizedFailureReason delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%d", self.HTTPResponse.statusCode] message:[[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
    });
}

-(NSArray *)statuses
{
    if ([self.request.path hasPrefix:@"/search"]) {
        return [self.json objectForKey:@"statuses"];
    }
    return self.json;
}

-(void)dealloc
{
    NSLog(@"dealloc response %p, request: %p", self, self.request);
}

@end
