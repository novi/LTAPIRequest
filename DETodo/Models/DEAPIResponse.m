//
//  DEAPIResponse.m
//  DETodo
//
//  Created by ito on 2013/03/21.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEAPIResponse.h"

@implementation DEAPIResponse

-(BOOL)success
{
    if (self.error || !self.responseData || self.parseError) {
        return NO;
    }
    if (self.HTTPResponse.statusCode >= 200 && self.HTTPResponse.statusCode < 300) {
        return YES;
    }
    return NO;
}

- (void)showErrorAlert
{
    // エラー時にアラートを出す
    // Main Queue 以外から呼ばれる可能性があるので Main Queue で実行する
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

@end
