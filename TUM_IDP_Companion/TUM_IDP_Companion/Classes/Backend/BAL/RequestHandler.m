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
    _greenNavBAL =  [GreenNavBAL new];
    
    return self;
}
- (void)sendRequest:(RequestType)requestType handler:(RequestBALHandler)handler {
    
    switch (requestType) {

        case RequestTypeAccessTwitterAccount:
            [self sendTwitterRequest:requestType handler:handler];
            
            break;
            
        case RequestTypeAccessFacebookAccount:
         [self sendFacebookRequest:requestType handler:handler];
            break;
            
            case RequestTypeAccessGreenNavTest:
            [self sendRequestGreenNav:requestType handler:handler];
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

- (void)sendRequestGreenNav:(RequestType)requestType handler:(RequestBALHandler)handler {
    
    switch (requestType) {
        default:
            //[_greenNavBAL sendTestVerticeSerivce:handler];
            //[_greenNavBAL sendTestVerticeNearestSerivce:handler];
            //[_greenNavBAL sendTestVehicles:handler];
            //[_greenNavBAL sendTestVehiclesSam:handler];
            //[_greenNavBAL sendTestVehiclesSamRoutes:handler];
            [_greenNavBAL sendTestVehiclesSamRoutesRate:handler];
            break;
    }

    
}
@end
