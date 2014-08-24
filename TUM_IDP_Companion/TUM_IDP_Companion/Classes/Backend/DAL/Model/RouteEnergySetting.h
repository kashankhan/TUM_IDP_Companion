//
//  RouteEnergySetting.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 24/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RouteEnergySetting : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * parameter;
@property (nonatomic, retain) NSNumber * selected;

@end
