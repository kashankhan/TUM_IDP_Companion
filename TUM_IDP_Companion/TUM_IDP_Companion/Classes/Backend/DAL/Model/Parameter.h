//
//  Parameter.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 15/11/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Link, Service, State;

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
@property (nonatomic, retain) NSSet *states;
@end

@interface Parameter (CoreDataGeneratedAccessors)

- (void)addStatesObject:(State *)value;
- (void)removeStatesObject:(State *)value;
- (void)addStates:(NSSet *)values;
- (void)removeStates:(NSSet *)values;

@end
