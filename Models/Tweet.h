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

@property (nonatomic, readonly, weak) Timeline* timeline; // get associated timeline

// Attributes
@property (nonatomic, readonly, copy) NSString* text;
@property (nonatomic, readonly, weak) User* byUser;
//@property (nonatomic, readonly, weak) User* originalUser;

// +-+-+-+-+-+-+ Private +-+-+-+-+-+-+ //
- (id)initWithData:(NSDictionary*)dict timeline:(Timeline*)timeline;

@end
