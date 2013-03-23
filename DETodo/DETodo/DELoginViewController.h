//
//  DELoginViewController.h
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DELoginViewController : UITableViewController

- (IBAction)cancelTapped:(id)sender;
- (IBAction)loginTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *loginField;

@end
