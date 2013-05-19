//
//  DETodoItem.m
//  DETodo
//
//  Created by ito on 2013/03/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DETodoItem.h"
#import "DETodoList.h"

extern void DELAY_TEST(dispatch_block_t block);

NSString* const DETodoItemDidChangeNotification = @"DETodoItemDidChangeNotification";

@implementation DETodoItem

-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(id)initWithData:(NSDictionary *)data list:(DETodoList *)list
{
    self = [super init];
    if (self) {
        [self replaceAttributesFromDictionary:data];
        _list = list;
    }
    return self;
}

-(id)initWithTitle:(NSString *)title list:(DETodoList *)list
{
    self = [super init];
    if (self) {
        [self setAttribute:title forKey:@"title"];
        _list = list;
    }
    return self;
}

-(void)itemCreatedWithData:(NSDictionary *)data
{
    [self replaceAttributesFromDictionary:data];
    [[NSNotificationCenter defaultCenter] postNotificationName:DETodoItemDidChangeNotification object:self];
}

#pragma mark - API

-(BOOL)isCreating
{
    if (!self.ID) {
        return YES;
    }
    return NO;
}

-(void)setDone:(BOOL)done callback:(LTModelGeneralCallback)callback
{
    BOOL oldVal = self.isDone;
    [self setAttribute:@(done) forKey:@"done"];
    [[NSNotificationCenter defaultCenter] postNotificationName:DETodoItemDidChangeNotification object:self];
    
    [[[DEAPIRequest alloc] initWithAPI:[NSString stringWithFormat:@"/list/%@/item/%@", self.list.ID, self.ID] method:LTAPIRequestMethodPUT params:@{@"done": @(done)}] sendRequestWithCallback:^(DEAPIResponse *res) {
        if (!res.success) {
            [self setAttribute:@(oldVal) forKey:@"done"]; // 失敗したら戻す
            callback(NO);
            [[NSNotificationCenter defaultCenter] postNotificationName:DETodoItemDidChangeNotification object:self];
            return;
        }
        callback(YES);
    }];
}

#pragma mark -

-(NSString *)ID
{
    return [self attributeForKey:@"_id"];
}


-(BOOL)isDone
{
    return [[self attributeForKey:@"done"] boolValue];
}

-(NSString *)title
{
    return [self attributeForKey:@"title"];
}

@end
