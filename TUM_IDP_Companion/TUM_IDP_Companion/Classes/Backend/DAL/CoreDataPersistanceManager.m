//
//  CoreDataPersistanceManager.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 27/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "CoreDataPersistanceManager.h"
#import "CoreData+MagicalRecord.h"

static NSString *kStoreName = @"TUM_IDP_Companion.sqlite";

@implementation CoreDataPersistanceManager

+ (CoreDataPersistanceManager *)sharedManager {
    static dispatch_once_t pred;
    static CoreDataPersistanceManager *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[CoreDataPersistanceManager alloc] init];
    });
    return shared;
}

- (instancetype) init {
    
    self = [super init];
    
    if (self) {
        [self setupPersistanceStore];
    }
    
    return self;
}

- (void)setupPersistanceStore {
    
    [self copyDefaultStoreIfNecessary];
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:kStoreName];
}

- (void) copyDefaultStoreIfNecessary {
	
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:kStoreName];
    
	// If the expected store doesn't exist, copy the default store.
	if (![fileManager fileExistsAtPath:[storeURL path]]) {
		NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:[kStoreName stringByDeletingPathExtension] ofType:[kStoreName pathExtension]];
        
		if (defaultStorePath) {
            NSError *error;
			BOOL success = [fileManager copyItemAtPath:defaultStorePath toPath:[storeURL path] error:&error];
            if (!success) {
                NSLog(@"Failed to install default recipe store");
            }
		}
	}
    
}

@end
