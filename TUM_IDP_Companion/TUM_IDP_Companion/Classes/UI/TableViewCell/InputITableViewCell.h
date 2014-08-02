//
//  InputITableViewCell.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputITableViewCell;

typedef void(^InputITableViewCellTextDidChangeHandler)(InputITableViewCell *cell, UITextField *textField);

@interface InputITableViewCell : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (copy, nonatomic) InputITableViewCellTextDidChangeHandler inputITableViewCellTextDidChangeHandler;

@end
