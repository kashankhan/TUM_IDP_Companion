//
//  MasterViewController.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 24/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
