//
//  InputTableViewCell.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "InputTableViewCell.h"

@implementation InputTableViewCell

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
    [self.textField setDelegate:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -UITextField Delegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField {

    if (self.inputTableViewCellTextDidChangeHandler) {
        self.inputTableViewCellTextDidChangeHandler(self, textField);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (self.inputTableViewCellTextDidChangeHandler) {
        self.inputTableViewCellTextDidChangeHandler(self, textField);
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    BOOL shouldChange = YES;
    if([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        shouldChange =  NO;
    }
    
    return shouldChange;
}

@end
