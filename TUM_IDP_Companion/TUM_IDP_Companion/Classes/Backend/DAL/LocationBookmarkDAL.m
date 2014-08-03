//
//  LocationBookmarkDAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "LocationBookmarkDAL.h"

@implementation LocationBookmarkDAL

- (NSArray *)locationBookmarks {

    return [LocationBookmark MR_findAllSortedBy:@"name" ascending:YES];
}

- (LocationBookmark *)newLocationBookmark {
    
   return [LocationBookmark MR_createEntity];
}

- (Landmark *)newLandmark {
    
    return [Landmark MR_createEntity];
}

- (NSArray *)landmarks {
    
    return [Landmark MR_findAll];
}

- (void)insertDefaultLandmarks {

    NSArray *defaulfLandmarks = @[NSLS_HOME, NSLS_OFFICE];
    for (NSString *option in defaulfLandmarks) {
        Landmark *landmark = [self newLandmark];
        [landmark setName:option];
    }
}

@end
