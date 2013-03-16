//
//  TimelineViewController.m
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "TimelineViewController.h"
#import "Timeline.h"
#import "Tweet.h"
#import "APIRequest.h"
#import "User.h"

@interface TimelineViewController ()
{
    BOOL _loadingMore;
}
@end

@implementation TimelineViewController

-(void)setTimeline:(Timeline *)timeline
{
    _timeline = timeline;
    [self.tableView reloadData];
    [self updateViews];
}

- (void)updateViews
{    
    self.navigationItem.title = _timeline.localizedTitle;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [self updateViews];
}

- (void)refresh:(UIRefreshControl*)sender
{
    [sender beginRefreshing];
    [_timeline refreshWithCallback:^(BOOL success, NSIndexSet *updatedIndexes) {
        [sender endRefreshing];
        if (success) {
            [self.tableView reloadData];
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!_timeline.tweets.count) {
        [self refresh:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _timeline.tweets.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        Tweet* tweet = [_timeline.tweets objectAtIndex:indexPath.row];
        cell.textLabel.text = tweet.text;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@/%@", tweet.ID, tweet.byUser.screenName, tweet.byUser.name];
    } else {
        cell.textLabel.text = @"Load more...";
        cell.detailTextLabel.text = _loadingMore ? @"loading...." : nil;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        Tweet* tweet = [_timeline.tweets objectAtIndex:indexPath.row];
        Timeline* timeline = tweet.byUser.mainTimeline;
        [[self.navigationController.viewControllers objectAtIndex:0] performSegueWithIdentifier:@"timeline" sender:timeline];
    } else {
        if (!_loadingMore) {
            _loadingMore = YES;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
            [_timeline loadMoreWithCallback:^(BOOL success, NSIndexSet *updatedIndexes) {
                _loadingMore = NO;
                if (success) {
                    [self.tableView reloadData];
                } else {
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
                }
            }];
        }
    }
}

@end
