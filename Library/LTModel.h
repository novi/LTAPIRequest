//
//  LTModel.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LTModelGeneralCallback)(BOOL success);

@interface LTModel : NSObject

- (id)init;
@property (nonatomic, copy, readonly) NSString* ID;

// Model の属性を set/get する, 引数はすべて nil 以外
- (id)attributeForKey:(NSString*)key;
- (void)setAttribute:(id)attr forKey:(NSString*)key;
- (void)replaceAttributesFromDictionary:(NSDictionary*)dict;
- (void)mergeAttributesFromDictionary:(NSDictionary*)dict;
- (void)removeAttributeForKey:(NSString*)key;
- (void)removeAllAttributes;

// 同じIDのModelは同じインスタンスを使用する場合
- (id)initWithID:(NSString*)ID;
+ (id)modelWithID:(NSString*)ID;

// LTStoreableModel
// キャッシュ付き
//- (NSMutableDictionary*)dictionaryRepresentation;
//- (void)restoreFromDictionaryRepresentation:(NSDictionary*)dict;
//- (void)setModelID:(NSString*)ID; // self.ID

@end
