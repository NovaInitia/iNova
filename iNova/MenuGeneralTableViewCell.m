//
//  MenuGeneralTableViewCell.m
//  iNova
//
//  Created by Kyle Hughes on 4/17/12.
//  Copyright (c) 2012 Team Fedora. All rights reserved.
//

#import "MenuGeneralTableViewCell.h"

@implementation MenuGeneralTableViewCell

@synthesize titleLabel = _titleLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
