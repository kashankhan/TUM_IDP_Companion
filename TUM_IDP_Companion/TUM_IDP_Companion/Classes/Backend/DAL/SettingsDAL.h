//
//  SettingsDAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 05/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseDAL.h"
#import "MusicSetting.h"
#import "TemperatureSetting.h"

@interface SettingsDAL : BaseDAL

- (MusicSetting *)musicSetting;
- (TemperatureSetting *)temperatureSetting;
@end
