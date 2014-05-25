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

@implementation RequestHandler

- (void)sendRequest:(RequestType)requestType handler:(RequestBALHandler)handler {

    
    switch (requestType) {

        case RequestTypeAccessTwitterAccount:
            [self sendTwitterRequest:requestType handler:handler];
            
            break;
            
        case RequestTypeAccessFacebookAccount:
         [self sendFacebookRequest:requestType handler:handler];
            break;
            
        default:
            break;
    }
}

- (void)sendTwitterRequest:(RequestType)requestType handler:(RequestBALHandler)handler  {

    TwitterRequestBAL *requestBal = [TwitterRequestBAL new];
   
    switch (requestType) {
        case RequestTypeAccessTwitterAccount:
            [requestBal accessAccountWithHandler:handler];
            
            break;
            
        default:
            break;
    }

}


- (void)sendFacebookRequest:(RequestType)requestType handler:(RequestBALHandler)handler  {
    
    FacebookRequestBAL *requestBal = [FacebookRequestBAL new];
    
    switch (requestType) {
        case RequestTypeAccessFacebookAccount:
            [requestBal accessAccountWithHandler:handler];
            
            break;
            
        default:
            break;
    }
    
}
@end
