//
//  DETodoItem.h
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEModel.h"

// TodoItem の Attributes (isDoneやisCreating)が変更された時
extern NSString* const DETodoItemDidChangeNotification; // NSNotification.object is self

@class DETodoList;
@interface DETodoItem : LTModel

@property (nonatomic, readonly, weak) DETodoList* list; // parent
@property (nonatomic, readonly, copy) NSString* title;
@property (nonatomic, readonly) BOOL isDone;

@property (nonatomic, readonly) BOOL isCreating; // 作成中か(作成中はまだIDが無い)

- (id)initWithTitle:(NSString*)title list:(DETodoList*)list; // for CREATION
- (void)setDone:(BOOL)done callback:(LTModelGeneralCallback)callback;

// Private
- (id)initWithData:(NSDictionary*)data list:(DETodoList*)list;
- (void)itemCreatedWithData:(NSDictionary*)data;

@end
