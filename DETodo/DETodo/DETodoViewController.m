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

@interface DETodoViewController ()

@end

@implementation DETodoViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
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
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        if (![cell.accessoryView isKindOfClass:[UISwitch class]]) {
            UISwitch* sw = [[UISwitch alloc] initWithFrame:CGRectZero];
            [sw addTarget:self action:@selector(swChanged:) forControlEvents:UIControlEventValueChanged];
            [sw sizeToFit];
            cell.accessoryView = sw;
        }
        
        DETodoItem* item = [_todoList.todoItems objectAtIndex:indexPath.row];
        cell.textLabel.text = item.title;
        UISwitch* sw = (id)cell.accessoryView;
        sw.on = item.isDone;
        sw.tag = indexPath.row;
        if (item.isCreating) {
            sw.enabled = NO;
        } else {
            sw.enabled = YES;
        }
        
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

- (IBAction)addTextFieldEnded:(UITextField *)sender
{
    [sender resignFirstResponder];
    if (sender.text.length > 0) {
        DETodoItem* item = [[DETodoItem alloc] initWithTitle:sender.text list:_todoList];
        sender.text = @"";
        [_todoList addTodoItem:item callback:^(BOOL success, BOOL itemsChanged, NSIndexSet *insertedIndex) {
            if (insertedIndex) {
                [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:insertedIndex.firstIndex inSection:1]] withRowAnimation:UITableViewRowAnimationMiddle];
            } else if (itemsChanged) {
                [self.tableView reloadData];
            }
        }];
    }
}


- (void)todoItemUpdated:(NSNotification*)notif
{
    NSInteger index = [_todoList.todoItems indexOfObjectIdenticalTo:notif.object];
    if (index != NSNotFound) {
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}


@end