//
//  DEItemCell.h
//  DETodo
//
//  Created by ito on 2013/05/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DETodoItem;
@interface DEItemCell : UITableViewCell


@property (nonatomic, readonly) DETodoItem* item;
- (void)setItem:(DETodoItem *)item forIndex:(NSUInteger)index;
@property (nonatomic, readonly) UISwitch* doneSwitch;

@end
