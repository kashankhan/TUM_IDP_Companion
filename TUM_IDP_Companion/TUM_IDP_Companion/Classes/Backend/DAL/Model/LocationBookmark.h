//
//  LocationBookmark.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 19/11/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LocationBookmark : NSManagedObject

@property (nonatomic, retain) NSNumber * favourite;
@property (nonatomic, retain) NSString * landmarkType;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;

@end
