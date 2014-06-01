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

- (void)sendTestVerticeSerivce:(RequestBALHandler)handler {

   [self sendRequest:[_urlRequest urlRequestForTestVerticeSerivce] handler:handler];
}

- (void)sendTestVehicles:(RequestBALHandler)handler {
    
    [self sendRequest:[_urlRequest urlRequestForTestVehicles] handler:handler];
}

- (void)sendTestVehiclesSam:(RequestBALHandler)handler {

    [self sendRequest:[_urlRequest urlRequestForTestVehiclesSam] handler:handler];
}
@end
