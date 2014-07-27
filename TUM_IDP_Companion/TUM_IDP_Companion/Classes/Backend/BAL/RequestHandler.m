//
//  RequestHandler.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestHandler.h"
#import "RequestBAL.h"
#import "TwitterRequestBAL.h"
#import "FacebookRequestBAL.h"
#import "GreenNavBAL.h"
#import "VMSerivesRequestBAL.h"

@interface RequestHandler() {

    GreenNavBAL *_greenNavBAL;
    TwitterRequestBAL *_twitterRequestBAL;
    FacebookRequestBAL *_facebookRequestBAL;
    VMSerivesRequestBAL *_visoServicesRequestBAL;

}

@end


@implementation RequestHandler

- (instancetype)init {
    
    self  = [super init];
    
    _facebookRequestBAL = [FacebookRequestBAL new];
    _twitterRequestBAL = [TwitterRequestBAL new];
    _greenNavBAL = [GreenNavBAL new];
    _visoServicesRequestBAL = [VMSerivesRequestBAL new];
    
    return self;
}

- (void)sendRequest:(RequestType)requestType params:(NSDictionary *)params handler:(RequestBALHandler)handler; {
    
    switch (requestType) {

        case RequestTypeAccessTwitterAccount:
            [self sendTwitterRequest:requestType handler:handler];
            break;
            
        case RequestTypeAccessFacebookAccount:
            [self sendFacebookRequest:requestType handler:handler];
            break;
            
        case RequestTypeAccessGreenNearestVertice:
        case RequestTypeAccessGreenVehicles:
        case RequestTypeAccessGreenVehiclesType:
        case RequestTypeAccessGreenVehicleRoutes:
        case RequestTypeAccessGreenVehicleRange:
            [self sendRequestGreenNav:requestType params:params handler:handler];
        
        case RequestTypeAccessVisoServices:
            [self sendRequestVM:requestType params:params handler:handler];
        default:
            break;
    }
}

- (void)sendTwitterRequest:(RequestType)requestType handler:(RequestBALHandler)handler  {

   
    switch (requestType) {
            
        case RequestTypeAccessTwitterAccount:
            [_twitterRequestBAL accessAccountWithHandler:handler];
            
            break;
            
        default:
            break;
    }

}

- (void)sendFacebookRequest:(RequestType)requestType handler:(RequestBALHandler)handler  {
    
    switch (requestType) {
            
        case RequestTypeAccessFacebookAccount:
            [_facebookRequestBAL accessAccountWithHandler:handler];
            break;
            
        default:
            break;
    }
    
}

- (void)sendRequestGreenNav:(RequestType)requestType params:(id)params handler:(RequestBALHandler)handler {
    
    switch (requestType) {
        
        case RequestTypeAccessGreenNearestVertice:
            [_greenNavBAL sendRequestForNearestVertice:params handler:handler];
            break;
            
        case RequestTypeAccessGreenVehicles:
            [_greenNavBAL sendRequestForVehicles:handler];
            break;
            
        case RequestTypeAccessGreenVehiclesType:
            [_greenNavBAL sendRequestForVehiclesType:params handler:handler];
            break;
            
            case RequestTypeAccessGreenVehicleRoutes:
            [_greenNavBAL sendRequestForVehicleRoutes:params handler:handler];
            break;
            

        case RequestTypeAccessGreenVehicleRange:
            [_greenNavBAL sendRequestForVehicleRange:params handler:handler];
            
        default:
            break;
            
    }

}

- (void)sendRequestVM:(RequestType)requestType params:(id)params handler:(RequestBALHandler)handler {

    switch (requestType) {
        case RequestTypeAccessVisoServices:
            [_visoServicesRequestBAL sendRequestForServices:handler];
            break;
            
        default:
            break;
    }

}
@end
