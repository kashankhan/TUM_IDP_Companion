//
//  GreenNavUrlRequest.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 01/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "GreenNavUrlRequest.h"

@implementation GreenNavUrlRequest

static const NSString *kBaseURL = @"https://greennav.isp.uni-luebeck.de/greennav";

/**
 *  ///
 */

- (NSURLRequest*)urlRequestForNearestVerticeWithLatitude:(long)latitude longituide:(long)longituide {
    //@"/vertices/nearest?lat=48.23&lon=11.68"
    NSString *uri = [NSString stringWithFormat:@"/vertices/nearest?lat=%ld&lon=%ld", latitude, longituide];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET payload:requestData];
}

- (NSURLRequest*)urlRequestForVehicles {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vehicles"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET payload:requestData];
}


- (NSURLRequest*)urlRequestForVehiclesType:(NSString *)vehicleType {
    //@"/vehicles/Sam"
    NSString *uri = [NSString stringWithFormat:@"/vehicles/%@", vehicleType];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET payload:requestData];
}

- (NSURLRequest*)urlRequestForVehicleRoutes:(NSString *)vehicle toRoute:(long long)toRoute forRoute:(long long)forRoute optimization:(NSString *)optimization battery:(NSUInteger)battery {
    
    //@"/vehicles/Sam/routes/188633982600-182440800/opt/energy?battery=100
    NSString *uri = [NSString stringWithFormat:@"/vehicles/%@/routes/%lld-%lld/opt/%@?battery=%lu", vehicle, toRoute, forRoute, optimization, (unsigned long)battery];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET payload:requestData];
}

- (NSURLRequest*)urlRequestForVehicleRange:(NSString *)vehicle range:(long long)range battery:(NSUInteger)battery  {
    
    //@"/vehicles/Sam/ranges/188633982600?battery=2
    NSString *uri = [NSString stringWithFormat:@"/vehicles/%@/ranges/%lld?battery=%lu",vehicle, range, (unsigned long)battery];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET payload:requestData];
}

@end
