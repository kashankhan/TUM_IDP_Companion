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

    NSArray *musicSettings = [MusicSetting MR_findAll];
    MusicSetting *musicSetting = nil;
    
    if (![musicSettings count]) {
        musicSetting = [MusicSetting MR_createEntity];
        musicSetting.feedSelection = NSLS_DISCOVERY;
        musicSetting.channelSelection = NSLS_ARTISTS;
        musicSetting.choice = NSLS_ARTISTS;
    }
    else {
        musicSetting = [musicSettings lastObject];
    }
    
    return musicSetting;

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
