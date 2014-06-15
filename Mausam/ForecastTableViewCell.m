//
//  ForecastTableViewCell.m
//  Mausam
//
//  Created by Niyog Ray on 13/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import "ForecastTableViewCell.h"

@implementation ForecastTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
