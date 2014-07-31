//
//  VMServiceUrlRequest.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "UrlRequest.h"

@interface VMServiceUrlRequest : UrlRequest


- (NSURL *)urlForServiceParameterSubscribtion:(NSString *)subscribtionUri;

- (NSURLRequest*)urlRequestForServices;
- (NSURLRequest *)urlRequestForServiceParameterValue:(NSString *)valueUri;
- (NSURLRequest *)urlRequestForServiceParameterUpdateValue:(NSString *)valueUri value:(NSString *)value;
@end
