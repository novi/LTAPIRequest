//
//  User.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTModel.h"

@class DETimeline, ACAccount;
// 接頭語をとりあえず DE(Demo) に
@interface DEUser : LTModel

// ユーザーの持つ Timeline
@property (nonatomic, readonly) DETimeline* homeTimeline; // 自分のみ有効
@property (nonatomic, readonly) DETimeline* usersTimeline;
//@property (nonatomic, readonly) Timeline* mentionTimeline;

// ユーザーの情報
// View などから参照する
// 必要があれば追加していく
@property (nonatomic, readonly, copy) NSString* screenName;
@property (nonatomic, readonly, copy) NSString* name;
@property (nonatomic, readonly, copy) NSString* profileImageURL;

+ (DEUser*)me; // 自分(ログインしているユーザー)
@property (nonatomic, readonly) BOOL isMe; // User は自分か

- (void)refreshUserInfoWithCallback:(LTModelGeneralCallback)callback; // User の情報を取得 (Twitter API GET user/show)


- (void)save;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
// ViewController や View から見てプライベートなメソッド

// User ID で User を返すメソッド, 同じ User ID は同じインスタンスが返る, 未生成ならばインスタンス化して返す
+ (DEUser*)userWithUserID:(NSString*)userID;
@property (nonatomic) ACAccount* account;

@end
