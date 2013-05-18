//
//  DETodoListViewController.m
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DETodoListViewController.h"
#import "DEUser.h"
#import "DETodoList.h"
#import <objc/runtime.h>
#import "DETodoViewController.h"
#import "DEListCell.h"

@interface DETodoListViewController ()<UIAlertViewDelegate>
{
    __weak DEUser* _user;
}
@end

@implementation DETodoListViewController

// ログイン通知をModelから受けとる
- (void)userDidLogin:(NSNotification*)notif
{
    // ユーザーがログイン完了したら一覧を読み込む
    if (self.refreshControl) {
        [self refresh:self.refreshControl];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // User Model
        _user = [DEUser me];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:DEUserDidLoginNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([DEUser isAuthenticated]) {
        UIBarButtonItem* addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addList:)];
        [self.navigationItem setLeftBarButtonItem:addItem animated:animated];
    }
}

- (void)addList:(id)sender
{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"新規Todoリスト" message:nil delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"作成", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // 新規リスト作成
        NSString* text = [alertView textFieldAtIndex:0].text;
        if (text.length > 0) {
            // リストModelを作成
            DETodoList* list = [[DETodoList alloc] initWithTitle:text user:_user];
            // API に投げる
            [_user addTodoList:list callback:^(BOOL success, BOOL collectionChanged) {
                if (collectionChanged) {
                    [self.tableView reloadData];
                }
            }];
        }
    }
}



- (void)refresh:(UIRefreshControl*)sender
{
    // リスト一覧更新
    [sender beginRefreshing];
    [_user refreshTodoListsWithCallback:^(BOOL success, BOOL collectionChanged) {
        [sender endRefreshing];
        if (collectionChanged) {
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _user.todoLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DEListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    DETodoList* list = [_user.todoLists objectAtIndex:indexPath.row];
    
    // View(Cell) に Model (list) をセット
    cell.list = list;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // すぐに削除
        [_user deleteTodoListAtIndex:indexPath.row callback:^(BOOL success, BOOL collectionChanged) {
        }];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } 
}

#pragma mark - Table view delegate

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showItems"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForCell:sender];
        DETodoList* list = [_user.todoLists objectAtIndex:indexPath.row];
        // アイテム表示用のViewControllerを設定
        DETodoViewController* vc = (id)segue.destinationViewController;
        // アイテムを保持する親のリストModelをセット
        vc.todoList = list;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
