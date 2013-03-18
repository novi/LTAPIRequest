//
//  Timeline.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTModel.h"

typedef NS_ENUM(NSUInteger, TimelineType) {
    TimelineTypeHome,
    TimelineTypeUsers,
    TimelineTypeSearch,
};

typedef void(^TimelineRefreshCallback)(BOOL success, NSIndexSet* insertedIndexSet);

@class DEUser;
@interface DETimeline : LTModel

@property (nonatomic, readonly) TimelineType type;
@property (nonatomic, readonly, weak) DEUser* user; // この Timeline の User (親), 循環参照を避けるため weak
@property (nonatomic, readonly, copy) NSString* localizedTitle; // NavigationBar に表示するタイトルなど
@property (nonatomic, readonly, copy) NSArray* tweets; // Tweet 一覧

@property (nonatomic, readonly, copy) NSString* query; // 検索語 (self.type == TimelineTypeSearch 時)

- (id)initSearchTimelineWithQuery:(NSString*)query;

// タイムラインを更新
- (void)refreshWithCallback:(TimelineRefreshCallback)callback;

// 続きを取得 (間は未実装)
- (void)loadMoreWithCallback:(TimelineRefreshCallback)callback;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
// ViewController や View から見てプライベートなメソッド
- (id)initWithType:(TimelineType)type user:(DEUser*)user;
- (void)setSearchQuery:(NSString*)query;

@end
