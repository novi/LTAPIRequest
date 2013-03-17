//
//  SecondViewController.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "SecondViewController.h"
#import "Timeline.h"
#import "TimelineViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)searchFieldEditEnded:(UITextField *)sender
{
    [sender resignFirstResponder];
    Timeline* timeline = [[Timeline alloc] initSearchTimelineWithQuery:sender.text];
    [self performSegueWithIdentifier:@"timeline" sender:timeline];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"timeline"]) {
        TimelineViewController* vc = (id)segue.destinationViewController;
        vc.timeline = sender;
    }
}

@end
