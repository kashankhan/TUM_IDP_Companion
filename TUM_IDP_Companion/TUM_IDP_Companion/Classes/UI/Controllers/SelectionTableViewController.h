//
//  SelectionTableViewController.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 09/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectionTableViewControllerDidSelectObjectHandler)(NSString * object);

@interface SelectionTableViewController : UITableViewController

@property (nonatomic, weak) NSString *defaultOption;
@property (nonatomic, weak) NSArray *options;


@property (nonatomic, copy) SelectionTableViewControllerDidSelectObjectHandler selectionTableViewControllerDidSelectObjectHandler;
@end
