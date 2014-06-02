//
//  GreenNavUrlRequest.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 01/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "UrlRequest.h"

@interface GreenNavUrlRequest : UrlRequest

- (NSURLRequest*)urlRequestForTestVerticeSerivce;
- (NSURLRequest*)urlRequestForTestVerticeNearestSerivce;
- (NSURLRequest*)urlRequestForTestVehicles;
- (NSURLRequest*)urlRequestForTestVehiclesSam;
- (NSURLRequest*)urlRequestForTestVehiclesSamRoutes;
- (NSURLRequest*)urlRequestForTestVehiclesSamRoutesRate;

- (NSURLRequest*)urlRequestForNearestVerticeWithLatitude:(long)latitude longituide:(long)longituide;
- (NSURLRequest*)urlRequestForVehicles;
- (NSURLRequest*)urlRequestForVehiclesType:(NSString *)vehicleType;
- (NSURLRequest*)urlRequestForVehicleRoutes:(NSString *)vehicle toRoute:(long long)toRoute forRoute:(long long)forRoute optimization:(NSString *)optimization battery:(NSUInteger)battery;
- (NSURLRequest*)urlRequestForVehicleRoutes:(NSString *)vehicle range:(long long)range battery:(NSUInteger)battery;
@end
