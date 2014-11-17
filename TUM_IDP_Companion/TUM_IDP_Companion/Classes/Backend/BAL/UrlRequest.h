//
//  UrlRequest.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 01/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"


typedef NS_ENUM(NSUInteger, HTTPMethodType) {
    HTTPMethodTypeGET,
    HTTPMethodTypePOST,
    HTTPMethodTypePUT
};


@interface UrlRequest : RequestBAL

- (NSURLRequest*)urlRequestForURL:(NSURL*)url httpMethodType:(HTTPMethodType)httpMethodType payload:(NSData*)data;
- (NSURLRequest*)urlRequestForURL:(NSURL*)url httpMethodType:(HTTPMethodType)httpMethodType payload:(NSData*)data requestContentType:(RequestContentType)contentType;
@end
