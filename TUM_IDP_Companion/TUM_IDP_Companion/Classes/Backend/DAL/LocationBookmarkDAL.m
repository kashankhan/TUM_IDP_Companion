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
    
   return (LocationBookmark*)[self getObjectWithEntity:[LocationBookmark class] withPredicate:nil createNewIfNotFound:YES];
}

@end
