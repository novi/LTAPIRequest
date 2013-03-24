//
//  DELoginViewController.m
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DELoginViewController.h"
#import "DEUser.h"

@interface DELoginViewController ()

@end

@implementation DELoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)cancelTapped:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginTapped:(UIButton*)sender
{
    // Login ボタンを連打できないようにする
    sender.enabled = NO;
    [DEUser loginWithUserID:self.loginField.text callback:^(BOOL success) {
        if (success) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } else {
            sender.enabled = YES;
        }
    }];
}

@end
