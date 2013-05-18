//
//  DEItemCell.m
//  DETodo
//
//  Created by ito on 2013/05/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEItemCell.h"
#import "DETodoItem.h"

@implementation DEItemCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        UISwitch* sw = [[UISwitch alloc] initWithFrame:CGRectZero];
        [sw sizeToFit];
        self.accessoryView = sw;
    }
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
}

-(UISwitch *)doneSwitch
{
    return (id)self.accessoryView;
}

-(void)setItem:(DETodoItem *)item forIndex:(NSUInteger)index
{
    _item = item;
    
    self.textLabel.text = item.title;
    
    UISwitch* sw = self.doneSwitch;
    sw.on = item.isDone;
    sw.tag = index;
    if(sw.on) {
        self.textLabel.textColor = [UIColor lightGrayColor];
    } else {
        self.textLabel.textColor = [UIColor blackColor];
    }
    
    // 作成中は切り替えできないように
    if (item.isCreating) {
        sw.enabled = NO;
    } else {
        sw.enabled = YES;
    }
}

@end
