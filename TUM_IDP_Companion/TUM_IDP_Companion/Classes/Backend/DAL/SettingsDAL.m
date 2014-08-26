//
//  SettingsDAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 05/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SettingsDAL.h"

@implementation SettingsDAL

- (TemperatureSetting *)temperatureSetting {

    NSArray *temperatureSettings = [TemperatureSetting MR_findAll];
    TemperatureSetting *temperatureSetting = nil;
    
    if (![temperatureSettings count]) {
        temperatureSetting = [self createNeeEntity:[TemperatureSetting class]];
    }
    else {
        temperatureSetting = [temperatureSettings lastObject];
    }

    return temperatureSetting;
}

- (NSArray *)musicChannels {
    
    NSArray *channels = [MusicChannel MR_findAllSortedBy:@"name" ascending:YES];
    if (![channels count]) {
        NSArray *musicChannels = @[NSLS_LOCAL_MUSIC, NSLS_DISCOVERY, NSLS_INDIVIDUAL];
        for (NSString *name in musicChannels) {
            
            BOOL selected = ([[musicChannels objectAtIndex:0] isEqualToString:name]);

            MusicChannel *musicChannel = [self musicChannel:name];
            [musicChannel setName:name];
            [musicChannel setSelected:@(selected)];
        }
        
        channels = [self musicChannels];
    }
    
    return channels;
}

- (MusicChannel *)musicChannel:(NSString *)name {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
   
    MusicChannel *musicChannel = (MusicChannel *)[self objectWithEntity:[MusicChannel class] withPredicate:predicate createNewIfNotFound:YES];
    
    return musicChannel;
}


- (NSArray *)musicFeeds {

    NSArray *feeds = [MusicFeed MR_findAllSortedBy:@"name" ascending:YES];
    
    if (![feeds count]) {
        feeds = @[@"http://www.n-tv.de/rss</state>",
                  @"http://www.tagesschau.de/xml/rss2</state>",
                  @"http://rss2.focus.de/c/32191/f/443312/index.rss",
                  @"http://www.spiegel.de/schlagzeilen/index.rss",
                  @"http://www.sportschau.de/sportschauindex100_type-rss.feed",
                  @"http://www.n-tv.de/sport/rss",
                  @"http://rss2.focus.de/c/32191/f/443319/index.rss",
                  @"http://www.spiegel.de/sport/index.rss"];

        NSUInteger count = 1;
        for (NSString *uri in feeds) {
           
            BOOL selected = ([[feeds objectAtIndex:0] isEqualToString:uri]);
            NSString *name = [NSString stringWithFormat:@"Feed %d", count];
            MusicFeed *musicFeed = [self musicFeed:uri];
            [musicFeed setSelected:@(selected)];
            [musicFeed setName:name];
            [musicFeed setType:NSLS_NEWS];
            [musicFeed setUri:uri];
            count++;

        }
        
        feeds = [self musicFeeds];
    }
    
    return feeds;
}

- (MusicFeed *)musicFeed:(NSString *)uri {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uri = %@", uri];
    
    MusicFeed *musicFeed = (MusicFeed *)[self objectWithEntity:[MusicFeed class] withPredicate:predicate createNewIfNotFound:YES];
    
    return musicFeed;
}

- (MusicSong *)musicSong {
    
    NSArray *musicSongs = [MusicSong MR_findAll];
    MusicSong *musicSong = nil;
    if (![musicSongs count]) {
        musicSong = (MusicSong *)[self objectWithEntity:[MusicSong class] withPredicate:nil createNewIfNotFound:YES];
    }
    else {
        musicSong = [musicSongs lastObject];
    }

    return musicSong;
}

- (MusicArtist *)musicArtist {

    NSArray *musicArtists = [MusicArtist MR_findAll];
    MusicArtist *musicArtist = nil;
    if (![musicArtists count]) {
        musicArtist = (MusicArtist *)[self objectWithEntity:[MusicArtist class] withPredicate:nil createNewIfNotFound:YES];
    }
    else {
        musicArtist = [musicArtists lastObject];
    }
    
    return musicArtist;
}

- (RouteEnergySetting *)selectedRouteEnergySetting {
    
    NSArray *routeSettings = [self routeSettings];
    RouteEnergySetting *routeSetting = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"selected = 1"];
    NSArray *settings = [routeSettings filteredArrayUsingPredicate:predicate];
    if ([settings count]) {
        routeSetting = [settings lastObject];
    }
    else {
        routeSetting = routeSettings[0];
        routeSetting.selected = @(YES);
        [self saveContext];
    }
    
    return routeSetting;
}

- (NSArray *)routeSettings {
    
    NSArray *parameters = @[@{@"Energy-Efficient": NSLS_ENERGY_EFFICIENT},
                            @{@"Traffic": NSLS_TRAFFIC},
                            @{@"Fastest": NSLS_FASTEST}];
    NSString *parameter = nil;
    NSString *name = nil;
    
    NSMutableArray *routes = [@[] mutableCopy];
  
    for (NSDictionary *routeInfo in parameters) {
  
        parameter = [[routeInfo allKeys] lastObject];
        name = [routeInfo valueForKey:parameter];
        
        RouteEnergySetting *routeEnergySetting = [self routeEnergySetting:parameter];
        [routeEnergySetting setParameter:parameter];
        [routeEnergySetting setName:name];
        
        [routes addObject:routeEnergySetting];
    }
    
    return routes;

}
- (RouteEnergySetting *)routeEnergySetting:(NSString *)parameter {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parameter = %@", parameter];
    
    RouteEnergySetting *routeEnergySetting = (RouteEnergySetting *)[self objectWithEntity:[RouteEnergySetting class] withPredicate:predicate createNewIfNotFound:YES];
    
    return routeEnergySetting;
}
@end
