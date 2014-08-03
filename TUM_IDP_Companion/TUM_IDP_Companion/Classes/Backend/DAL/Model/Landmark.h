//
//  Landmark.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 03/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LocationBookmark;

@interface Landmark : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSOrderedSet *locationBookmarks;
@end

@interface Landmark (CoreDataGeneratedAccessors)

- (void)insertObject:(LocationBookmark *)value inLocationBookmarksAtIndex:(NSUInteger)idx;
- (void)removeObjectFromLocationBookmarksAtIndex:(NSUInteger)idx;
- (void)insertLocationBookmarks:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeLocationBookmarksAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInLocationBookmarksAtIndex:(NSUInteger)idx withObject:(LocationBookmark *)value;
- (void)replaceLocationBookmarksAtIndexes:(NSIndexSet *)indexes withLocationBookmarks:(NSArray *)values;
- (void)addLocationBookmarksObject:(LocationBookmark *)value;
- (void)removeLocationBookmarksObject:(LocationBookmark *)value;
- (void)addLocationBookmarks:(NSOrderedSet *)values;
- (void)removeLocationBookmarks:(NSOrderedSet *)values;
@end
