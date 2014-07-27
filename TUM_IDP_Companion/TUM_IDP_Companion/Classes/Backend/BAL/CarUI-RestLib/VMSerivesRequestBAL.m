//
//  VMSerivesRequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMSerivesRequestBAL.h"
#import "VMServiceUrlRequest.h"
#import "VMServiceParser.h"

@interface VMSerivesRequestBAL () {

    VMServiceUrlRequest *_urlRequest;
    VMServiceParser *_parser;
}

@end

@implementation VMSerivesRequestBAL

- (instancetype)init {
    
    self  = [super init];
    _urlRequest = [VMServiceUrlRequest new];
    _parser = [VMServiceParser new];
    
    return self;
}


- (void)sendRequestForServices:(RequestBALHandler)handler {

    NSURLRequest *urlRequest = [_urlRequest urlRequestForServices];
    [self sendRequest:urlRequest handler:^(id response, NSError *error) {
        
        handler([_parser parseServices:response], error);
    }];
}

@end
