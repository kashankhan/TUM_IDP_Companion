//
//  RequestBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestQueue.h"

// Completion block for performRequestWithHandler.
typedef void(^RequestBALHandler)(id response, NSError *error);


typedef NS_ENUM(NSUInteger, RequestContentType) {
    RequestContentTypeJSON,
    RequestContentTypePlainText,
    RequestContentTypeImage
};

@interface RequestBAL : NSObject {

    RequestQueue *_requestQueue;
    
}

- (void)cancelAllOperations;
- (void)addOperation:(RQOperation *)operation;

- (void)sendRequest:(NSURLRequest *)request handler:(RequestBALHandler)handler;
@end
