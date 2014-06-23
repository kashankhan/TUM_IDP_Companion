//
//  SwitchTableViewCell.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 22/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchTableViewCell;

typedef void(^SwitchTableViewSwitchValueChangelHandler)(SwitchTableViewCell *switchTableViewCell, UISwitch *switchControl);


@interface SwitchTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (copy, nonatomic) SwitchTableViewSwitchValueChangelHandler switchTableViewSwitchValueChangelHandler;

@end
