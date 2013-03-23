//
//  LTModel.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^LTModelGeneralCallback)(BOOL success);
typedef void(^LTModelCollectionCallback)(BOOL success, BOOL collectionChanged);

@interface LTModel : NSObject

- (id)init;
@property (nonatomic, copy, readonly) NSString* ID;

// Model の属性を set/get する, 引数はすべて nil 以外, サブクラスのみから呼ぶ(ViewやViewControllerに対してはPrivate)
- (id)attributeForKey:(NSString*)key;
- (void)setAttribute:(id)attr forKey:(NSString*)key;
- (void)replaceAttributesFromDictionary:(NSDictionary*)dict;
- (void)mergeAttributesFromDictionary:(NSDictionary*)dict;
- (void)removeAttributeForKey:(NSString*)key;
- (void)removeAllAttributes;
- (NSDictionary*)attributes;

// 同じIDのModelは同じインスタンスを使用する場合, サブクラスでオーバーライド
- (id)initWithID:(NSString*)ID;
// 同じIDのModelは同じインスタンスを返す(まだ無ければ生成)
+ (id)modelWithID:(NSString*)ID;

// TODO: 
// LTStorableModel, キャッシュ付き
//- (NSMutableDictionary*)dictionaryRepresentation;
//- (void)restoreFromDictionaryRepresentation:(NSDictionary*)dict;

@end
