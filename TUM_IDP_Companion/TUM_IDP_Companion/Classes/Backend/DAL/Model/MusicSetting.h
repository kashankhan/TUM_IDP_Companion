//
//  MusicSetting.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 05/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MusicSetting : NSManagedObject

@property (nonatomic, retain) NSString * catagory;
@property (nonatomic, retain) NSString * musicType;
@property (nonatomic, retain) NSString * selectedOption;

@end
