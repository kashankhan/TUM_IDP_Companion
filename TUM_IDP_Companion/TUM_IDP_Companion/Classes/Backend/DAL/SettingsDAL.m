//
//  SettingsDAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 05/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SettingsDAL.h"

@implementation SettingsDAL

- (MusicSetting *)musicSetting {

    return nil;
}

- (TemperatureSetting *)temperatureSetting {

    NSArray *temperatureSettings = [TemperatureSetting MR_findAll];
    TemperatureSetting *temperatureSetting = nil;
    
    if (![temperatureSettings count]) {
        temperatureSetting = [TemperatureSetting MR_createEntity];
    }
    else {
        temperatureSetting = [temperatureSettings lastObject];
    }

    return temperatureSetting;
}

@end
