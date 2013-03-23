//
//  DETodoList.m
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DETodoList.h"
#import "DETodoItem.h"

#import "LTAPIRequest.h"
void DELAY_TEST(dispatch_block_t block)
{
    [LTAPIRequest beginNetworkConnection];
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^() {
        [LTAPIRequest endNetworkConnection];
        block();
    });
}

NSString* const DETodoListDidChangeNotification = @"DETodoListDidChangeNotification";
NSString* const DETodoListTodoItemsDidChangeNotification = @"DETodoListTodoItemsDidChangeNotification";


@interface DETodoList ()
{
    NSMutableArray* _items;
}
@end

@implementation DETodoList

-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(id)initWithTitle:(NSString *)title user:(DEUser *)user
{
    self = [super init];
    if (self) {
        _user = user;
        [self setAttribute:title forKey:@"title"];
        _items = [NSMutableArray array];
    }
    return self;
}

-(id)initWithData:(NSDictionary *)data user:(DEUser *)user
{
    self = [super init];
    if (self) {
        [self replaceAttributesFromDictionary:data];
        _user = user;
        _items = [NSMutableArray array];
    }
    return self;
}

#pragma mark -


-(NSArray *)todoItems
{
    return _items;
}

-(NSString *)ID
{
    return [self attributeForKey:@"_id"];
}


-(NSString *)title
{
    return [self attributeForKey:@"title"];
}

-(NSDictionary *)createDictionary
{
    return @{@"title": [self attributeForKey:@"title"]};
//    return [self attributes]; // or
}

-(void)listCreatedWithData:(NSDictionary *)data
{
    [self replaceAttributesFromDictionary:data];
}

#pragma mark - API

-(void)refreshTodoItemsWithCallback:(LTModelCollectionCallback)callback
{
    [[[DEAPIRequest alloc] initWithAPI:[NSString stringWithFormat:@"/list/%@/item", self.ID] method:LTAPIRequestMethodGET params:nil] sendRequestWithCallback:^(DEAPIResponse *res) {
        if (!res.success) {
            callback(NO, NO);
            return;
        }
        _items = [NSMutableArray array];
        for (NSDictionary* dict in [res.json objectForKey:@"items"]) {
            DETodoItem* item = [[DETodoItem alloc] initWithData:dict list:self];
            [_items addObject:item];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DETodoListTodoItemsDidChangeNotification object:self];
        callback(YES, YES);
    }];
}

-(void)addTodoItem:(DETodoItem *)item callback:(DETodoListTodoItemAddCallback)callback
{
    // 作成してすぐに _items に追加して、失敗したら戻す設計にした (UI的に)
    [_items insertObject:item atIndex:0];
    callback(YES, YES, [NSIndexSet indexSetWithIndex:0]);
    
    [[[DEAPIRequest alloc] initWithAPI:[NSString stringWithFormat:@"/list/%@/item", self.ID] method:LTAPIRequestMethodPOST params:@{@"title": item.title}] sendRequestWithCallback:^(DEAPIResponse *res) {
        if (!res.success) {
            [_items removeObjectIdenticalTo:item]; // rollback
            callback(NO, YES, nil);
            [[NSNotificationCenter defaultCenter] postNotificationName:DETodoListTodoItemsDidChangeNotification object:self];
            return;
        }
        [item itemCreatedWithData:res.json];
        callback(YES, NO, nil);
    }];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DETodoListTodoItemsDidChangeNotification object:self];
}

-(void)deleteTodoItemAtIndex:(NSUInteger)index callback:(LTModelCollectionCallback)callback
{
    // TableView(or CollectionView)を使うので _items からはすぐに消す
    
    DETodoItem* oldItem = [_items objectAtIndex:index];
    
    [_items removeObjectAtIndex:index];
    
    [[[DEAPIRequest alloc] initWithAPI:[NSString stringWithFormat:@"/list/%@/item/%@", self.ID, oldItem.ID] method:LTAPIRequestMethodDELETE params:nil] sendRequestWithCallback:^(DEAPIResponse *res) {
        if (!res.success) {
            [_items addObject:oldItem]; // failed, roll back
            callback(NO, YES);
            [[NSNotificationCenter defaultCenter] postNotificationName:DETodoListTodoItemsDidChangeNotification object:self];
            return;
        }
        callback(YES, NO);
    }];
    
    // TableViewの特性から_itemsが変更されているがCallbackは呼ばない
    
    //
    [[NSNotificationCenter defaultCenter] postNotificationName:DETodoListTodoItemsDidChangeNotification object:self];
}


@end
