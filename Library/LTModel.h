//
//  LTModel.h
//  LTAPIRequest
//
//  Created by Yusuke Ito on 2013/03/16.
//  Copyright (c) 2013 Yusuke Ito. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
