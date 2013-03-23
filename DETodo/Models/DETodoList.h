//
//  DETodoList.h
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEModel.h"

typedef void(^DETodoListTodoItemAddCallback)(BOOL success, BOOL itemsChanged, NSIndexSet* insertedIndex);

// TodoList の Attributes (titleなど) が変更された時(ただし変更, PUT は無いので今回は使わない)
extern NSString* const DETodoListDidChangeNotification; // object is self, may be not in use
// TodoList の Items が変更された時
extern NSString* const DETodoListTodoItemsDidChangeNotification; // object is self

@class DETodoItem, DEUser;
@interface DETodoList : LTModel

@property (nonatomic, readonly, weak) DEUser* user; // parent
@property (nonatomic, readonly, copy) NSString* title;

@property (nonatomic, readonly, copy) NSArray* todoItems; // DETodoItem

- (id)initWithTitle:(NSString*)title user:(DEUser*)user; // for CREATION

- (void)refreshTodoItemsWithCallback:(LTModelCollectionCallback)callback;
- (void)addTodoItem:(DETodoItem*)item callback:(DETodoListTodoItemAddCallback)callback; // callbackは2度呼ばれます
- (void)deleteTodoItemAtIndex:(NSUInteger)index callback:(LTModelCollectionCallback)callback;

// Private
- (id)initWithData:(NSDictionary *)data user:(DEUser *)user;
- (NSDictionary*)createDictionary;
- (void)listCreatedWithData:(NSDictionary*)data;

@end
