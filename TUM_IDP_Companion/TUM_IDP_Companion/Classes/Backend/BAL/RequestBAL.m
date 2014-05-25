//
//  RequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"
#import "RequestQueue.h"

@implementation RequestBAL

- (instancetype)init {
    
    self  = [super init];
    _requestQueue = [[RequestQueue alloc] init];
    _requestQueue.allowDuplicateRequests = YES;
    
    return self;
}

- (void)sendRequest:(NSURL *)url parameters:(NSDictionary *)parameters handler:(RequestBALHandler)handler {


}
@end
