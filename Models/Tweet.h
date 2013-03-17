//
//  Tweet.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTModel.h"

@class Timeline, User;
@interface Tweet : LTModel

@property (nonatomic, readonly, weak) Timeline* timeline; // このツイートが含まれる Timeline オブジェクト (親), 循環参照を避けるため weak

// Attributes
@property (nonatomic, readonly, copy) NSString* text; // ツイート
@property (nonatomic, readonly, weak) User* byUser; // ツイートしたユーザー, 循環参照を避けるため weak
//@property (nonatomic, readonly, weak) User* originalUser;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
// ViewController や View から見てプライベートなメソッド
- (id)initWithData:(NSDictionary*)dict timeline:(Timeline*)timeline; // timeline: このツイートが含まれる Timeline オブジェクト (親)

@end
