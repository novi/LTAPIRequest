//
//  DEUser.h
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEModel.h"

// todoLists が変更されたら通知する
extern NSString* const DEUserTodoListsDidChangeNotification; // object is self

// ログイン完了後
extern NSString* const DEUserDidLoginNotification; // object is self;

@class DETodoList;
@interface DEUser : LTModel

+ (DEUser*)me;
+ (BOOL)isAuthenticated;

+ (void)loginWithUserID:(NSString*)userID callback:(LTModelGeneralCallback)callback;
@property (nonatomic, readonly, copy) NSString* userID;

@property (nonatomic, readonly, copy) NSArray* todoLists; // DETodoList

- (void)refreshTodoListsWithCallback:(LTModelCollectionCallback)callback;
- (void)addTodoList:(DETodoList*)todolist callback:(LTModelCollectionCallback)callback;
- (void)deleteTodoListAtIndex:(NSUInteger)index callback:(LTModelCollectionCallback)callback;

@end
