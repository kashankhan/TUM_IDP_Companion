//
//  LocationBookmarkDAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "LocationBookmarkDAL.h"

@implementation LocationBookmarkDAL

- (id)init {
    
    self = [super init];
    
    if (self) {
        [self deleteUnFavoriteLocationBookmarks];
    }
    
    return self;
}

- (NSArray *)locationBookmarks {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favourite = 1"];
    return [LocationBookmark MR_findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
}

- (LocationBookmark *)newLocationBookmark {
    
    return [self createNeeEntity:[LocationBookmark class]];
}

- (Landmark *)newLandmark {
    
    return [self createNeeEntity:[Landmark class]];
}

- (NSArray *)landmarks {
    
    return [Landmark MR_findAllSortedBy:@"name" ascending:YES];
}

- (void)insertDefaultLandmarks {

    NSArray *defaulfLandmarks = @[NSLS_HOME, NSLS_OFFICE];
    for (NSString *option in defaulfLandmarks) {
        Landmark *landmark = [self newLandmark];
        [landmark setName:option];
    }
}

- (void)deleteUnFavoriteLocationBookmarks {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favourite = 0"];
    NSArray *locationBookmarks = [LocationBookmark MR_findAllSortedBy:@"name" ascending:YES withPredicate:predicate];
    for (LocationBookmark *locationBookmark in locationBookmarks) {
        [locationBookmark MR_deleteEntity];
    }
}

@end
