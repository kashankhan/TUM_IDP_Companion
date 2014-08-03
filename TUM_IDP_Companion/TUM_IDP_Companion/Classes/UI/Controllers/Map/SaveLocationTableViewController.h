//
//  SaveLocationTableViewController.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTableViewCell.h"
#import "LocationBookmarkDAL.h"
#import "LocationHelper.h"

@interface SaveLocationTableViewController : UITableViewController {

    NSMutableArray *_items;
}

@property (strong, nonatomic) Landmark *selectedLandmark;
@end
