//
//  DETodoViewController.m
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DETodoViewController.h"
#import "DETodoList.h"
#import "DETodoItem.h"
#import "DEItemCell.h"

@interface DETodoViewController ()

@end

@implementation DETodoViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // TodoItemが1つアップデートされたらそのRowをリロードする
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(todoItemUpdated:) name:DETodoItemDidChangeNotification object:nil];
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.refreshControl && _todoList && _todoList.todoItems.count == 0) {
        [self refresh:self.refreshControl];
    }
}

- (void)refresh:(UIRefreshControl*)sender
{
    if (!_todoList) {
        return;
    }
    
    [sender beginRefreshing];
    [_todoList refreshTodoItemsWithCallback:^(BOOL success, BOOL shouldBeReloaded) {
        [sender endRefreshing];
        if (shouldBeReloaded) {
            [self.tableView reloadData];
        }
    }];
}


-(void)setTodoList:(DETodoList *)todoList
{
    _todoList = todoList;
    self.navigationItem.title = todoList.title;
    self.title = todoList.title;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Section 0 は追加用のTextField用
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return _todoList.todoItems.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"addCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *CellIdentifier = @"Cell";
        DEItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        DETodoItem* item = [_todoList.todoItems objectAtIndex:indexPath.row];
        
        // View(Cell)にModelをセット
        [cell setItem:item forIndex:indexPath.row];
        
        [cell.doneSwitch removeTarget:self action:NULL forControlEvents:UIControlEventValueChanged];
        [cell.doneSwitch addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
        
        return cell;

    }
    return nil;
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}

- (void)swChanged:(UISwitch*)sender
{
    // Done状態の更新
    __weak DETodoItem* item = [_todoList.todoItems objectAtIndex:sender.tag];
    [item setDone:sender.on callback:^(BOOL success) {
        
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_todoList deleteTodoItemAtIndex:indexPath.row callback:^(BOOL success, BOOL shouldBeReloaded) {
            if (shouldBeReloaded) {
                [self.tableView reloadData];
            }
        }];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark -

// 新規TodoItem追加
- (IBAction)addTextFieldEnded:(UITextField *)sender
{
    [sender resignFirstResponder];
    if (sender.text.length > 0) {
        // Todo Item のModelを作成
        DETodoItem* item = [[DETodoItem alloc] initWithTitle:sender.text list:_todoList];
        sender.text = @"";
        // リクエストを送る
        [_todoList addTodoItem:item callback:^(BOOL success, BOOL itemsChanged, NSIndexSet *insertedIndex) {
            if (insertedIndex) {
                // 挿入された場所のTableを更新
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:insertedIndex.firstIndex inSection:1]] withRowAnimation:UITableViewRowAnimationMiddle];
            } else if (itemsChanged) {
                [self.tableView reloadData];
            }
        }];
    }
}


- (void)todoItemUpdated:(NSNotification*)notif
{
    // Todo Item の値(isDoneなど)が更新されたらそのRowをリロード
    NSInteger index = [_todoList.todoItems indexOfObjectIdenticalTo:notif.object];
    if (index != NSNotFound) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end
