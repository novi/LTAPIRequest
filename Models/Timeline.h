//
//  Timeline.h
//  LTTwDemo
//
//  Created by ito on 2013/03/16.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "LTModel.h"

typedef NS_ENUM(NSUInteger, TimelineType) {
    TimelineTypeMain = 0,
    TimelineTypeSearch,
};

typedef void(^TimelineRefreshCallback)(BOOL success, NSIndexSet* insertedIndexSet);

@class User;
@interface Timeline : LTModel

@property (nonatomic, readonly) TimelineType type;
@property (nonatomic, readonly, weak) User* user;
@property (nonatomic, readonly, copy) NSString* localizedTitle;
@property (nonatomic, readonly, copy) NSArray* tweets; // Tweet

@property (nonatomic, readonly, copy) NSString* query;

- (id)initSearchTimelineWithQuery:(NSString*)query;

- (void)refreshWithCallback:(TimelineRefreshCallback)callback;
- (void)loadMoreWithCallback:(TimelineRefreshCallback)callback;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
- (id)initWithType:(TimelineType)type user:(User*)user;
- (void)setSearchQuery:(NSString*)query;

@end
