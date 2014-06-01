//
//  RequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"


@implementation RequestBAL

- (instancetype)init {
    
    self  = [super init];
    _requestQueue = [[RequestQueue alloc] init];
    _requestQueue.allowDuplicateRequests = YES;
    
    return self;
}

- (void)cancelAllOperations {
    
    [_requestQueue cancelAllRequests];
}

- (void)addOperation:(RQOperation *)operation {
    
    [_requestQueue addOperation:operation];
}


- (void)sendRequest:(NSURLRequest *)request handler:(RequestBALHandler)handler {
    
    RQOperation* operation = [RQOperation operationWithRequest:request];
    operation.completionHandler =  ^(NSURLResponse *response, NSData *data, NSError *error) {
       
        NSString *responseValue = nil;
        if (!error) {
            responseValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        }
        if (handler) {
            handler(responseValue, error);
        }

        NSLog(@" response : %@", responseValue);
        NSLog(@" error : %@", [error localizedDescription]);
    };
    [self addOperation:operation];
}
@end
