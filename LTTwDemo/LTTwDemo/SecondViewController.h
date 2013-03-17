//
//  SecondViewController.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController

- (IBAction)searchFieldEditEnded:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)viewTapped:(id)sender;

@end
