//
//  FirstViewController.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "FirstViewController.h"
#import "APIRequest.h"
#import "User.h"
#import "TimelineViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)login:(UIButton*)sender
{
    // ボタン連打防止
    sender.enabled = NO;
    ACAccountStore* store = [APIRequest accountStore];
    [store requestAccessToAccountsWithType:[store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter] options:nil completion:^(BOOL granted, NSError *error) {
        // completion は Main Queue で実行されない場合があるので注意
        if (granted && !error) {
            // success
            dispatch_async(dispatch_get_main_queue(), ^{
                // 2つ以上のアカウントがある場合どちらかが適当に選択される
                ACAccount* account = [[store accounts] lastObject];
                NSLog(@"%@", account);
                User* me = [User me];
                me.account = account;
                
                [me refreshUserInfoWithCallback:^(BOOL success) {
                    if (success) {
                        [self performSegueWithIdentifier:@"timeline" sender:me.homeTimeline];
                    }
                    sender.enabled = YES;
                    return;
                }];
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                sender.enabled = YES;
                return;
            });
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeline"]) {
        TimelineViewController* vc = (id)segue.destinationViewController;
        vc.timeline = sender;
    }
}

@end
