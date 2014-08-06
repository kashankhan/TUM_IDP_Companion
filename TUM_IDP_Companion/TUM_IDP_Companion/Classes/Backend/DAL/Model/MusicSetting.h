//
//  MusicSetting.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 06/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MusicSetting : NSManagedObject

@property (nonatomic, retain) NSString * feedSelection;
@property (nonatomic, retain) NSString * channelSelection;
@property (nonatomic, retain) NSString * choice;

@end
