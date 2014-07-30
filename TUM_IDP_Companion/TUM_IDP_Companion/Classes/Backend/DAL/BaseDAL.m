//
//  BaseDAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseDAL.h"
#import "CoreDataPersistanceManager.h"

@interface BaseDAL ()

@property (strong, nonatomic) CoreDataPersistanceManager *persistanceManager;
@end

@implementation BaseDAL

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        self.persistanceManager = [CoreDataPersistanceManager sharedManager];
    }
    
    return self;
}

- (NSManagedObject*)getObjectWithEntity:(Class)entityClass withPredicate:(NSPredicate*)predicate createNewIfNotFound:(BOOL)create {
    
    NSManagedObject *manageObject = nil;
    NSArray *list = [entityClass MR_findAllWithPredicate:predicate];
    // check if the user info is no exist create the new one.
    if (![list count]) {
        if (create) {
            manageObject = [entityClass MR_createEntity];
        }
    }
    else {
        manageObject = [list objectAtIndex:0];
    }
    
    return manageObject;
    
}

- (void)saveContext {
    
    [self.persistanceManager saveContext];
}

@end
