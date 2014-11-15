//
//  State.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 15/11/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Parameter;

@interface State : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) Parameter *parameter;

@end
