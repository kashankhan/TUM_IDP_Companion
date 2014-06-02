//
//  GreenNavBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 01/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "GreenNavBAL.h"
#import "GreenNavUrlRequest.h"

@interface GreenNavBAL() {

    GreenNavUrlRequest *_urlRequest;
}

@end

@implementation GreenNavBAL

- (instancetype)init {
    
    self  = [super init];
    _urlRequest = [GreenNavUrlRequest new];
    
    return self;
}


- (void)sendRequestForNearestVertice:(NSDictionary *)params handler:(RequestBALHandler)handler {

    long latitude = 48.23;
    long longitude = 11.68;
    NSURLRequest *urlRequest = [_urlRequest urlRequestForNearestVerticeWithLatitude:latitude longituide:longitude];
    [self sendRequest:urlRequest handler:handler];
}


- (void)sendRequestForVehicles:(RequestBALHandler)handler {

    NSURLRequest *urlRequest = [_urlRequest urlRequestForVehicles];
    [self sendRequest:urlRequest handler:handler];
}

- (void)sendRequestForVehiclesType:(NSDictionary *)params handler:(RequestBALHandler)handler {

    NSString *type = @"Sam";
   
    NSURLRequest *urlRequest = [_urlRequest urlRequestForVehiclesType:type];
    [self sendRequest:urlRequest handler:handler];
}

- (void)sendRequestForVehicleRoutes:(NSDictionary *)params handler:(RequestBALHandler)handler {

    NSString *type = @"Sam";
    long long toRoute = 188633982600;
    long long forRoute = 182440800;
    NSString *optimization = @"energy";
    NSUInteger battery = 100;
    
     NSURLRequest *urlRequest = [_urlRequest urlRequestForVehicleRoutes:type toRoute:toRoute forRoute:forRoute optimization:optimization battery:battery];
    [self sendRequest:urlRequest handler:handler];
    
}

- (void)sendRequestForVehicleRange:(NSDictionary *)params handler:(RequestBALHandler)handler {
    
    NSString *type = @"Sam";
    long long range = 188633982600;
    NSUInteger battery = 100;
    
    NSURLRequest *urlRequest = [_urlRequest urlRequestForVehicleRange:type range:range battery:battery];
    [self sendRequest:urlRequest handler:handler];
    
}

@end
