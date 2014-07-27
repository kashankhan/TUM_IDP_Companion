//
//  VMServiceUrlRequest.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceUrlRequest.h"

@implementation VMServiceUrlRequest

static const NSString *kBaseURL = @"http://vmkrcmar59.informatik.tu-muenchen.de:8080";

- (NSURLRequest*)urlRequestForServices {
    
    NSString *uri = [kBaseURL stringByAppendingString:@"/services"];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}
@end
