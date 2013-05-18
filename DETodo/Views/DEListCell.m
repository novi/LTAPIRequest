//
//  DEListCell.m
//  DETodo
//
//  Created by ito on 2013/05/19.
//  Copyright (c) 2013年 novi. All rights reserved.
//

#import "DEListCell.h"
#import "DETodoList.h"

@implementation DEListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setList:(DETodoList *)list
{
    _list = list;
    
    self.textLabel.text = list.title;
    //self.detailTextLabel.text = [NSString stringWithFormat:@"%d項目", list.todoItems.count];
}

@end
