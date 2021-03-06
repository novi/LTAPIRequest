//
//  APIResponse.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEAPIResponse.h"
#import "DEAPIRequest.h"

@implementation DEAPIResponse

//
#pragma mark -
// オーバーライド

//パース後処理, 任意, コメントを外す
-(NSError *)parseJSON
{
    NSError* parseError = [super parseJSON];
    if (!parseError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"json parsed");
        });
    }
    return parseError;
}


-(BOOL)success
{
    // 成功時か失敗かの判定をここに記述する
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

#pragma mark -

-(NSArray *)statuses
{
    // API によってツイート一覧(statuses)のキーが違うので差違をここで吸収する
    
    if ([self.request.path hasPrefix:@"/search"]) {
        return [self.json objectForKey:@"statuses"];
    }
    return self.json;
}

-(void)dealloc
{
    NSLog(@"dealloc response %p - %@, request: %p - %@", self, NSStringFromClass([self class]), self.request, NSStringFromClass([self.request class]));
}

@end
