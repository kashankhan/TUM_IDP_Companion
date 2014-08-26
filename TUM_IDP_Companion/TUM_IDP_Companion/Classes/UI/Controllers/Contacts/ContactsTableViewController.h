//
//  ContactsTableViewController.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactsDAL;

@interface ContactsTableViewController : UITableViewController {

    ContactsDAL *_contactDal;
    NSMutableArray *_addressBookContacts;
    NSMutableArray *_items;
}

@end
