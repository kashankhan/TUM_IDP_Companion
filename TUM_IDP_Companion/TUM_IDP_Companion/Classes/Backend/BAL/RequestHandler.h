//
//  RequestHandler.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestBAL.h"

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeAccessTwitterAccount,
    RequestTypeAccessFacebookAccount,
     RequestTypeAccessGreenNavTest
};

@interface RequestHandler : NSObject

- (void)sendRequest:(RequestType)requestType handler:(RequestBALHandler)handler;
@end
