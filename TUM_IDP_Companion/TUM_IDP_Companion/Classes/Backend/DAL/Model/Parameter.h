//
//  Parameter.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 27/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Link, Service;

@interface Parameter : NSManagedObject

@property (nonatomic, retain) NSNumber * lowerBound;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * readOnly;
@property (nonatomic, retain) NSNumber * stepSize;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * unitSymbol;
@property (nonatomic, retain) NSNumber * upperBound;
@property (nonatomic, retain) Link *link;
@property (nonatomic, retain) Service *service;

@end
