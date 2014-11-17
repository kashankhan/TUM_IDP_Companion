//
//  UrlRequest.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 01/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "UrlRequest.h"

@implementation UrlRequest


static const NSString *kBoundary = @"0xKhTmLbOuNdArY";

- (void)setHeaderInDictionary:(NSMutableDictionary*)headerFields {
    
}


- (NSMutableURLRequest *)request:(NSURL *)url {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    return request;
}

- (NSURLRequest*)urlRequestForURL:(NSURL*)url payload:(NSData*)data httpMethod:(NSString *)httpMethod requestContentType:(RequestContentType)contentTye {
    
    NSMutableURLRequest *request = [self request:url];
    NSMutableDictionary* headerWithCookies = [NSMutableDictionary dictionary];
  
    NSString *contetTypeValue = nil;
    
    switch (contentTye) {

        case RequestContentTypePlainText:
            contetTypeValue = @"text/plain; charset=UTF-8";
            break;
        
        case RequestContentTypeImage:
            contetTypeValue = [NSString stringWithFormat:@"multipart/form-data; charset=UTF-8; boundary=%@", kBoundary];
            break;
            
        case RequestContentTypeForm:
            contetTypeValue = @"application/x-www-form-urlencoded; charset=UTF-8";
            break;
            
        case RequestContentTypeJSON:
        default:
            contetTypeValue = @"application/json; charset=UTF-8";
            break;
    }//switch
    
    [headerWithCookies setValue:contetTypeValue forKey:@"Content-Type"];
    
    [self setHeaderInDictionary:headerWithCookies];
    [request setAllHTTPHeaderFields:headerWithCookies];
    [request setHTTPMethod:httpMethod];
    [request setHTTPBody:data];
    return request;
}

- (NSURLRequest*)urlRequestForGetURL:(NSURL*)url {
    
    NSMutableURLRequest *request = [self request:url];
    NSMutableDictionary* headerWithCookies = [NSMutableDictionary dictionary];
    [self setHeaderInDictionary:headerWithCookies];
    [request setAllHTTPHeaderFields:headerWithCookies];
    [request setHTTPMethod:@"GET"];
    return request;
}


- (NSURLRequest*)urlRequestForURL:(NSURL*)url httpMethodType:(HTTPMethodType)httpMethodType payload:(NSData*)data {

    return [self urlRequestForURL:url httpMethodType:httpMethodType  payload:data requestContentType:RequestContentTypeJSON];
}

- (NSURLRequest*)urlRequestForURL:(NSURL*)url httpMethodType:(HTTPMethodType)httpMethodType payload:(NSData*)data requestContentType:(RequestContentType)contentType {

    NSURLRequest *request = nil;
    if (httpMethodType == HTTPMethodTypePOST) {
        request = [self urlRequestForURL:url payload:data httpMethod:@"POST" requestContentType:contentType];
        
    }//if
    else if (httpMethodType == HTTPMethodTypePUT) {
        request = [self urlRequestForURL:url payload:data httpMethod:@"PUT" requestContentType:contentType];
        
    }//if else
    else {
        request = [self urlRequestForGetURL:url];
        
    }//else
    
    return request;
}

@end
