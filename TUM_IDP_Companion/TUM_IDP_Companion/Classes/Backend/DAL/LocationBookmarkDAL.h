//
//  LocationBookmarkDAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseDAL.h"
#import "LocationBookmark.h"
#import "Landmark.h"

@interface LocationBookmarkDAL : BaseDAL

- (NSArray *)locationBookmarks;

- (LocationBookmark *)newLocationBookmark;
- (Landmark *)newLandmark;
- (NSArray *)landmarks;
- (void)insertDefaultLandmarks;
- (void)deleteUnFavoriteLocationBookmarks;
@end
