//
//  DEUser.m
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEUser.h"
#import "DETodoList.h"

extern void DELAY_TEST(dispatch_block_t block);

NSString* const DEUserTodoListsDidChangeNotification = @"DEUserTodoListsDidChangeNotification";
NSString* const DEUserDidLoginNotification = @"DEUserDidLoginNotification";

@interface DEUser ()
{
    BOOL _isAuthenticated;
    NSMutableArray* _todolists;
}
@end

@implementation DEUser

- (id)init
{
    self = [super init];
    if (self) {
        _todolists = [NSMutableArray array];
    }
    return self;
}

+(DEUser *)me
{
    static id me;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        me = [[self alloc] init];
    });
    return me;
}

+(BOOL)isAuthenticated
{
    return [[self me] userID] ? YES : NO;
}

+(void)loginWithUserID:(NSString *)userID callback:(LTModelGeneralCallback)callback
{
    [[[DEAPIRequest alloc] initWithAPI:@"/auth/login" method:LTAPIRequestMethodPOST params:@{@"user_id": userID}] sendRequestWithCallback:^(DEAPIResponse *res) {
        if (!res.success) {
            callback(NO);
            return;
        }
        [[DEUser me] replaceAttributesFromDictionary:res.json];
        callback(YES);
        [[NSNotificationCenter defaultCenter] postNotificationName:DEUserDidLoginNotification object:[DEUser me]];
    }];
}

-(NSArray *)todoLists
{
    return _todolists;
}

-(NSString *)ID
{
    return [self attributeForKey:@"_id"];
}

-(NSString *)userID
{
    return [self attributeForKey:@"user_id"];
}

#pragma mark - API 

-(void)refreshTodoListsWithCallback:(LTModelCollectionCallback)callback
{
    [[[DEAPIRequest alloc] initWithAPI:@"/list" method:LTAPIRequestMethodGET params:nil] sendRequestWithCallback:^(DEAPIResponse *res) {
        if (!res.success) {
            callback(NO, NO);
            return;
        }
        _todolists = [NSMutableArray array];
        for (NSDictionary* dict in [res.json objectForKey:@"lists"]) {
            DETodoList* list = [[DETodoList alloc] initWithData:dict user:self];
            [_todolists addObject:list];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DEUserTodoListsDidChangeNotification object:self];
        callback(YES, YES);
    }];
}


-(void)addTodoList:(DETodoList *)todolist callback:(LTModelCollectionCallback)callback
{
    [[[DEAPIRequest alloc] initWithAPI:@"/list" method:LTAPIRequestMethodPOST params:todolist.createDictionary] sendRequestWithCallback:^(DEAPIResponse *res) {
        if (!res.success) {
            callback(NO, NO);
            return ;
        }
        // リクエストに成功してから _todolist に追加するような設計にした
        [todolist listCreatedWithData:res.json];
        [_todolists insertObject:todolist atIndex:0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:DEUserTodoListsDidChangeNotification object:self];
        callback(YES, YES);
    }];
}

-(void)deleteTodoListAtIndex:(NSUInteger)index callback:(LTModelCollectionCallback)callback
{
    DETodoList* list = [_todolists objectAtIndex:index];
    
    // TableView を使うのですぐに _todolists から削除
    [_todolists removeObjectAtIndex:index];
    
    [[[DEAPIRequest alloc] initWithAPI:[NSString stringWithFormat:@"/list/%@", list.ID] method:LTAPIRequestMethodDELETE params:nil] sendRequestWithCallback:^(DEAPIResponse *res) {
        // 失敗しても(APIRequestレベルで)アラートを表示するだけでrollbackしない
        //[[NSNotificationCenter defaultCenter] postNotificationName:DEUserTodoListsDidChangeNotification object:self];
        //callback(YES, NO);
    }];
        
    // 同じく TableView を使うので _todolists が変更されているがCallbackしない
}

@end
