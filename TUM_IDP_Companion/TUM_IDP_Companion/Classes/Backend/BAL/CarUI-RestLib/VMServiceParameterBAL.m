//
//  VMServiceParameterBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 31/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceParameterBAL.h"
#import "EventSource.h"

NSString* const kParameterSubcribtionUriKey = @"ParameterSubcribtionUriKey";
NSString* const kParameterValueUriKey = @"ParameterValueUriKey";
NSString* const kParameterUpdatedValueKey = @"ParameterUpdatedValueKey";

@implementation VMServiceParameterBAL

- (void)sendRequestForParameterValue:(id)params handler:(RequestBALHandler)handler {
    
    NSString *valueUri = [params valueForKey:kParameterValueUriKey];
    NSURLRequest *urlRequest = [self.urlRequest urlRequestForServiceParameterValue:valueUri];
    [self sendRequest:urlRequest handler:^(id response, NSError *error) {
        
        handler(response, error);
    }];
}


- (void)sendRequestForServiceParameterUpdateValue:(id)params handler:(RequestBALHandler)handler {
    
    NSString *valueUri = [params valueForKey:kParameterValueUriKey];
    NSString *value = [params valueForKey:kParameterUpdatedValueKey];
    NSURLRequest *urlRequest = [self.urlRequest urlRequestForServiceParameterUpdateValue:valueUri value:value];
    [self sendRequest:urlRequest handler:^(id response, NSError *error) {
        
        handler(response, error);
    }];
}

- (void)subscribeEvent:(id)params handler:(RequestBALHandler)handler {

    NSString *subscribtionUri = [params valueForKey:kParameterSubcribtionUriKey];
    NSURL *url = [self.urlRequest urlForServiceParameterSubscribtion:subscribtionUri];
    EventSource *eventSource = [EventSource eventSourceWithURL:url];
    [eventSource addEventListener:@"push-event" handler:^(Event *event) {
        
        NSLog(@"test : %@",event.data);
        handler(event.data, event.error);
    }];
}
@end
