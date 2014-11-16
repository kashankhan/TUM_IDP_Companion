//
//  RequestBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "AFURLSessionManager.h"

// Completion block for performRequestWithHandler.
typedef void(^RequestBALHandler)(id response, NSError *error);


typedef NS_ENUM(NSUInteger, RequestContentType) {
    RequestContentTypeJSON,
    RequestContentTypePlainText,
    RequestContentTypeImage,
    RequestContentTypeForm
};

@interface RequestBAL : NSObject

- (void)cancelAllOperations;

- (AFURLSessionManager*)sessionManager;

- (void)sendRequest:(NSURLRequest *)request handler:(RequestBALHandler)handler;

- (void)sendRequest:(NSURLRequest *)request manager:(AFURLSessionManager *)manager handler:(RequestBALHandler)handler;

@end
