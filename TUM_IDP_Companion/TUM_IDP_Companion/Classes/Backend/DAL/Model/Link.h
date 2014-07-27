//
//  Link.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Link : NSManagedObject

@property (nonatomic, retain) NSString * subscription;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSManagedObject *parameter;

@end
