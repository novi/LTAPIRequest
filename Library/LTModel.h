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

@property (nonatomic, copy, readonly) NSString* ID;

- (id)attributeForKey:(NSString*)key;
- (void)setAttribute:(id)attr forKey:(NSString*)key;
- (void)replaceAttributesFromDictionary:(NSDictionary*)dict;
- (void)mergeAttributesFromDictionary:(NSDictionary*)dict;
- (void)removeAllAttributes;

//- (NSMutableDictionary*)dictionaryRepresentation;
//- (void)restoreFromDictionaryRepresentation:(NSDictionary*)dict;
//- (void)setModelID:(NSString*)ID; // self.ID

@end
