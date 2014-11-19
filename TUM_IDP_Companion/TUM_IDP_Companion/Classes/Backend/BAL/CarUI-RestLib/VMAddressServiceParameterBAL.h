//
//  VMAddressServiceParameterBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 15/11/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceParameterBAL.h"
#import "LocationBookmark.h"

typedef NS_ENUM(NSUInteger, AddressType) {
    AddressTypeHome,
    AddressTypeOffice,
    AddressTypeFavorite1,
    AddressTypeFavorite2,
    AddressTypeFavorite3,
    AddressTypeFavorite4,
    AddressTypeFavorite5
};

@interface VMAddressServiceParameterBAL : VMServiceParameterBAL

- (void)updateAddress:(LocationBookmark *)locationBookmark addressType:(AddressType)addressType handler:(RequestBALHandler)handler;
@end
