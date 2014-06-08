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

@interface RequestHandler() {

    GreenNavBAL *_greenNavBAL;
    TwitterRequestBAL *_twitterRequestBAL;
    FacebookRequestBAL *_facebookRequestBAL;

}

@end


@implementation RequestHandler

- (instancetype)init {
    
    self  = [super init];
    
    _facebookRequestBAL = [FacebookRequestBAL new];
    _twitterRequestBAL = [TwitterRequestBAL new];
    _greenNavBAL = [GreenNavBAL new];
    
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
            [self sendRequestGreenNav:requestType params:params handler:handler];
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
        default:

            [_greenNavBAL sendRequestForVehicles:handler];
            [_greenNavBAL sendRequestForVehiclesType:params handler:handler];
            [_greenNavBAL sendRequestForVehicleRoutes:params handler:handler];
            [_greenNavBAL sendRequestForVehicleRange:params handler:handler];
            
    }

    
}
@end
