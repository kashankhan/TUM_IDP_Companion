//
//  VMServiceParameterBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 31/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceParameterBAL.h"
#import "EventSource.h"

@interface VMServiceParameterBAL() {
    
    EventSource *_eventSource;
}

@end

NSString* const kParameterSubcribtionUriKey = @"ParameterSubcribtionUriKey";
NSString* const kParameterValueUriKey = @"ParameterValueUriKey";
NSString* const kParameterUpdatedValueKey = @"ParameterUpdatedValueKey";

@implementation VMServiceParameterBAL


- (void)sendRequestForParameterValue:(id)params handler:(RequestBALHandler)handler {
    
    NSString *valueUri = [params valueForKey:kParameterValueUriKey];
    NSURLRequest *urlRequest = [self.urlRequest urlRequestForServiceParameterValue:valueUri];
    [self sendRequest:urlRequest handler:^(id response, NSError *error) {
        NSLog(@"response : %@",response);
        handler(response, error);
    }];
}


- (void)sendRequestForServiceParameterUpdateValue:(id)params handler:(RequestBALHandler)handler {
    
    NSString *valueUri = [params valueForKey:kParameterValueUriKey];
    NSString *value = [params valueForKey:kParameterUpdatedValueKey];
    NSURLRequest *urlRequest = [self.urlRequest urlRequestForServiceParameterUpdateValue:valueUri value:value];
    [self sendRequest:urlRequest handler:^(id response, NSError *error) {
        NSLog(@"response : %@",response);
        handler(response, error);
    }];
}

- (void)sendRequestForSubscribeEvent:(id)params handler:(RequestBALHandler)handler {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *subscribtionUri = [params valueForKey:kParameterSubcribtionUriKey];
        NSURL *url = [self.urlRequest urlForServiceParameterSubscribtion:subscribtionUri];
        _eventSource = [EventSource eventSourceWithURL:url];
        [_eventSource addEventListener:@"push-event" handler:^(Event *event) {
            
            NSLog(@"test : %@",event.data);
            handler(event.data, event.error);
        }];
    });
    

}
@end
