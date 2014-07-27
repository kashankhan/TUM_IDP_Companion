//
//  Service.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Service : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *parameters;
@end

@interface Service (CoreDataGeneratedAccessors)

- (void)addParametersObject:(NSManagedObject *)value;
- (void)removeParametersObject:(NSManagedObject *)value;
- (void)addParameters:(NSSet *)values;
- (void)removeParameters:(NSSet *)values;

@end
