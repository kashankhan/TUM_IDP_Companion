//
//  ContantTableViewCell.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 29/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContantTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

- (void)setContent:(id)object;
@end
