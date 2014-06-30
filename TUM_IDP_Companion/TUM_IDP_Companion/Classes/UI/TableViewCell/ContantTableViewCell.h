//
//  ContantTableViewCell.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 29/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContantTableViewCell;

typedef void (^ContantTableViewCellEventHandler)(ContantTableViewCell *cell, id sender);

@interface ContantTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

- (void)setFavoriteButtonSelected:(BOOL)selected;

@property (copy, nonatomic) ContantTableViewCellEventHandler eventHandler;
@end
