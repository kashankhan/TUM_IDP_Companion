//
//  LocationHelper.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

typedef void(^LocationHelperHandler)(CLLocationCoordinate2D coordinate);

@interface LocationHelper : NSObject

+ (void)locationFromAddress:(NSString*)address handler:(LocationHelperHandler)locationHelperHandler;
@end
