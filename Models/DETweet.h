//
//  Tweet.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTModel.h"

@class DETimeline, DEUser;
@interface DETweet : LTModel

@property (nonatomic, readonly, weak) DETimeline* timeline; // このツイートが含まれる Timeline オブジェクト (親), 循環参照を避けるため weak

// Attributes
@property (nonatomic, readonly, copy) NSString* text; // ツイート
@property (nonatomic, readonly, weak) DEUser* byUser; // ツイートしたユーザー, 循環参照を避けるため weak
//@property (nonatomic, readonly, weak) User* originalUser;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
// ViewController や View から見てプライベートなメソッド
- (id)initWithData:(NSDictionary*)dict timeline:(DETimeline*)timeline; // timeline: このツイートが含まれる Timeline オブジェクト (親)

@end
