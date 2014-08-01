//
//  SearchLocationTableViewController.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 08/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef void(^SearchLocationTableViewControllerHandler)(id object);

@interface SearchLocationTableViewController : UITableViewController

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, copy) SearchLocationTableViewControllerHandler searchLocationTableViewControllerHandler;

@end
