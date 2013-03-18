//
//  SecondViewController.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "SecondViewController.h"
#import "DETimeline.h"
#import "TimelineViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchField becomeFirstResponder];
}

- (IBAction)searchFieldEditEnded:(UITextField *)sender
{
    [sender resignFirstResponder];
    DETimeline* timeline = [[DETimeline alloc] initSearchTimelineWithQuery:sender.text];
    [self performSegueWithIdentifier:@"timeline" sender:timeline];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeline"]) {
        TimelineViewController* vc = (id)segue.destinationViewController;
        vc.timeline = sender;
    }
}

- (IBAction)viewTapped:(id)sender
{
    [self.searchField resignFirstResponder];
}
@end
