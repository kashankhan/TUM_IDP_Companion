//
//  TripPlannerTableViewController.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 08/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TripPlannerTableViewControllerDidSelectObjectHandler)(NSMutableDictionary * objectInfo);

@interface TripPlannerTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *tripLocations;

@property (nonatomic, copy) TripPlannerTableViewControllerDidSelectObjectHandler tripPlannerTableViewControllerDidSelectObjectHandler;


@end