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


- (NSURLRequest*)urlRequestForTestVerticeSerivce {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vertices/nearest?lat=48.23&lon=11.68"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest*)urlRequestForTestVerticeNearestSerivce {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vertices/nearest?lat=48.25&lon=11.65"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest*)urlRequestForTestVehicles {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vehicles"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}


- (NSURLRequest*)urlRequestForTestVehiclesSam {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vehicles/Sam"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest*)urlRequestForTestVehiclesSamRoutes {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vehicles/Sam/routes/188633982600-182440800/opt/energy?battery=100"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest*)urlRequestForTestVehiclesSamRoutesRate {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vehicles/Sam/ranges/188633982600?battery=2"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

/**
 *  ///
 */

- (NSURLRequest*)urlRequestForNearestVerticeWithLatitude:(long)latitude longituide:(long)longituide {
    //@"/vertices/nearest?lat=48.23&lon=11.68"
    NSString *uri = [NSString stringWithFormat:@"/vertices/nearest?lat=%ld&lon=%ld", latitude, longituide];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest*)urlRequestForVehicles {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/vehicles"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}


- (NSURLRequest*)urlRequestForVehiclesType:(NSString *)vehicleType {
    //@"/vehicles/Sam"
    NSString *uri = [NSString stringWithFormat:@"/vehicles/%@", vehicleType];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest*)urlRequestForVehicleRoutes:(NSString *)vehicle toRoute:(long)toRoute forRoute:(long)forRoute optimization:(NSString *)optimization battery:(NSUInteger)battery {
    
    //@"/vehicles/Sam/routes/188633982600-182440800/opt/energy?battery=100
    NSString *uri = [NSString stringWithFormat:@"/vehicles/%@/routes/%ld-%ld/opt/%@?battery=%d", vehicle, toRoute, forRoute, optimization, battery];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest*)urlRequestForVehicleRoutes:(NSString *)vehicle range:(long)range battery:(NSUInteger)battery  {
    
    //@"/vehicles/Sam/ranges/188633982600?battery=2
    NSString *uri = [NSString stringWithFormat:@"/vehicles/%@/ranges/%ld?battery=%d",vehicle, range, battery];
    uri = [kBaseURL stringByAppendingString:uri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

@end
