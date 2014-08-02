//
//  VMServiceRequestBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"
#import "VMServiceUrlRequest.h"
#import "VMServiceParser.h"

@interface VMServiceRequestBAL : RequestBAL

@property (nonatomic, strong) VMServiceUrlRequest *urlRequest;
@property (nonatomic, strong) VMServiceParser *parser;

- (void)sendRequestForServices:(RequestBALHandler)handler;
@end
