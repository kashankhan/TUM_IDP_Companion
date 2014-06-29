//
//  ContactsDAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseDAL.h"
@import AddressBook;
#import "ABWrappers.h"

@interface ContactsDAL : BaseDAL

- (NSArray *)addressBook;
@end
