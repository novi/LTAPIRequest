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

@class User;
@interface Timeline : LTModel

@property (nonatomic, readonly) TimelineType type;
@property (nonatomic, readonly, weak) User* user; // この Timeline の User (親)
@property (nonatomic, readonly, copy) NSString* localizedTitle; // NavigationBar に表示するタイトルなど
@property (nonatomic, readonly, copy) NSArray* tweets; // Tweet 一覧

@property (nonatomic, readonly, copy) NSString* query; // 検索語 (self.type == TimelineTypeSearch 時)

- (id)initSearchTimelineWithQuery:(NSString*)query;

- (void)refreshWithCallback:(TimelineRefreshCallback)callback;
- (void)loadMoreWithCallback:(TimelineRefreshCallback)callback;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
- (id)initWithType:(TimelineType)type user:(User*)user;
- (void)setSearchQuery:(NSString*)query;

@end
