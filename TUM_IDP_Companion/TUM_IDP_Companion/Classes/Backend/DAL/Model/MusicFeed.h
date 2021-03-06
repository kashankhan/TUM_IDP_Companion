//
//  MusicFeed.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 17/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MusicFeed : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * selected;
@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSString * type;

@end
