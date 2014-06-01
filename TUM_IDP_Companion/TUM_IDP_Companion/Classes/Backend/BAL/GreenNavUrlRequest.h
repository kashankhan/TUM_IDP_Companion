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
@end
