//
//  RequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"

@interface RequestBAL ()

@property (nonatomic, strong) AFURLSessionManager *manager;
@end

@implementation RequestBAL


- (void)cancelAllOperations {
    
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)dealloc {
    
    [self cancelAllOperations];
}

- (AFURLSessionManager*)sessionManager {
    
    if (!self.manager) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
    }
    
    return self.manager;
}

- (void)sendRequest:(NSURLRequest *)request manager:(AFURLSessionManager *)manager handler:(RequestBALHandler)handler {
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if(handler) handler(responseObject, error);
    }];
    [dataTask resume];
    
}

- (void)sendRequest:(NSURLRequest *)request handler:(RequestBALHandler)handler {
    
    AFURLSessionManager *manager = [self sessionManager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [self sendRequest:request manager:manager handler:handler];
}

@end
