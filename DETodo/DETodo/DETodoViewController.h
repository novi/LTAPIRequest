//
//  DETodoViewController.h
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DETodoList;
@interface DETodoViewController : UITableViewController

@property (nonatomic, weak) DETodoList* todoList;
- (IBAction)addTextFieldEnded:(UITextField *)sender;

@end
