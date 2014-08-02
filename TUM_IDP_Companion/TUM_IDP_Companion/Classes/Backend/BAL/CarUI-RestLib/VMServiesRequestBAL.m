//
//  VMSerivesRequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceRequestBAL.h"


@interface VMServiceRequestBAL ()

@end

@implementation VMServiceRequestBAL

- (instancetype)init {
    
    self  = [super init];
    self.urlRequest = [VMServiceUrlRequest new];
    self.parser = [VMServiceParser new];
    
    return self;
}


- (void)sendRequestForServices:(RequestBALHandler)handler {

    NSURLRequest *urlRequest = [_urlRequest urlRequestForServices];
    [self sendRequest:urlRequest handler:^(id response, NSError *error) {
        
        handler([self.parser parseServices:response], error);
    }];
}


@end
