//
//  BaseDAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData+MagicalRecord.h"

@interface BaseDAL : NSObject

- (NSManagedObject*)getObjectWithEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate createNewIfNotFound:(BOOL)create;
- (void)saveContext;
@end
