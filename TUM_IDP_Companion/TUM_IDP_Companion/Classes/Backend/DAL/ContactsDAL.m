//
//  ContactsDAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "ContactsDAL.h"
@import AddressBook;

@implementation ContactsDAL


- (NSArray *)addressBook {

    NSArray *contacts = nil;
    switch ([ABStandin authorizationStatus]) {
        case kABAuthorizationStatusAuthorized:
            contacts = [ABContactsHelper contacts];
            break;
            
        case  kABAuthorizationStatusRestricted:
        case  kABAuthorizationStatusDenied:
            [ABStandin requestAccess];
            break;
    case kABAuthorizationStatusNotDetermined:
        default:
            //[ABStandin showDeniedAccessAlert];
             [ABStandin requestAccess];
            break;
    }
    
    return contacts;

}

@end
