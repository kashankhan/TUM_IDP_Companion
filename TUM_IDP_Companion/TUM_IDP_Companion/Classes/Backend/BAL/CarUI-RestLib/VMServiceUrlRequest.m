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

- (NSString *)servicesUri {
    
    return [kBaseURL stringByAppendingString:@"/services"];
}

- (NSURL *)urlForServiceParameterSubscribtion:(NSString *)subscribtionUri {
    
    NSString *uri = [[self servicesUri] stringByAppendingFormat:@"/%@", subscribtionUri];
    
    return [NSURL URLWithString:uri];
}

- (NSURLRequest*)urlRequestForServices {
    
    NSString *uri = [self servicesUri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}

- (NSURLRequest *)urlRequestForServiceParameterValue:(NSString *)valueUri {

    NSString *uri = [[self servicesUri] stringByAppendingFormat:@"/%@", valueUri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET withPayLoad:requestData];
}


- (NSURLRequest *)urlRequestForServiceParameterUpdateValue:(NSString *)valueUri value:(NSString *)value {
    
    NSString *uri = [[self servicesUri] stringByAppendingFormat:@"/%@", valueUri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = [value dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypePOST withPayLoad:requestData withRequestContentType:RequestContentTypeForm ];
}

@end
