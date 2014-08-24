//
//  SettingsDAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 05/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseDAL.h"
#import "MusicChannel.h"
#import "MusicSong.h"
#import "MusicArtist.h"
#import "MusicFeed.h"
#import "TemperatureSetting.h"
#import "RouteEnergySetting.h"

@interface SettingsDAL : BaseDAL

- (TemperatureSetting *)temperatureSetting;
- (NSArray *)musicChannels;
- (NSArray *)musicFeeds;
- (MusicSong *)musicSong;
- (MusicArtist *)musicArtist;
- (NSArray *)routeSettings;
- (RouteEnergySetting *)selectedRouteEnergySetting;
@end
