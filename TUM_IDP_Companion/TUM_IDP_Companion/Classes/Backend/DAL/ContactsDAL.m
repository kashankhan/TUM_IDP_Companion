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

- (NSArray *)contacts {

    return [Contact MR_findAll];
}

- (Contact *)contact:(NSString *)identifier createNewIfNotFound:(BOOL)create {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    return (Contact *)[self objectWithEntity:[Contact class] withPredicate:predicate createNewIfNotFound:create];
}

@end
