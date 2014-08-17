//
//  ContactsDAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseDAL.h"
#import "ABWrappers.h"
#import "Contact.h"

@interface ContactsDAL : BaseDAL

- (NSArray *)addressBook;
- (NSArray *)contacts;
- (Contact *)contact:(NSString *)identifier createNewIfNotFound:(BOOL)create;
@end
