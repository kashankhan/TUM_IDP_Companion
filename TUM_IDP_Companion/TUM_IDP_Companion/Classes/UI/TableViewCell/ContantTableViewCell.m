//
//  ContantTableViewCell.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 29/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "ContantTableViewCell.h"

@implementation ContantTableViewCell

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

- (void)setContent:(id)object {

}

@end
