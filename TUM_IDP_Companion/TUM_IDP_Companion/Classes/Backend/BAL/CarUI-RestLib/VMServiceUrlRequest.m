//
//  VMServiceUrlRequest.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceUrlRequest.h"

@implementation VMServiceUrlRequest

//http://vmkrcmar59.informatik.tu-muenchen.de/visiom2GetIp.php for getting server IP
//static const NSString *kBaseURL = @"http://vmkrcmar59.informatik.tu-muenchen.de:8080";
static const NSString * kBaseURL = @"http://131.159.195.229:8080";
//static const NSString *kBaseURL = @"http://localhost:8080";

- (NSString *)servicesUri {
    
    return [kBaseURL stringByAppendingString:@"/services"];
}

- (NSURL *)urlForServiceParameterSubscribtion:(NSString *)subscribtionUri {
    
    NSString *uri = [[self servicesUri] stringByAppendingFormat:@"/%@", subscribtionUri];
    NSLog(@"url : %@",uri);
    return [NSURL URLWithString:uri];
}

- (NSURLRequest*)urlRequestForServices {
    
    NSString *uri = [self servicesUri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET payload:requestData];
}

- (NSURLRequest *)urlRequestForServiceParameterValue:(NSString *)valueUri {

    NSString *uri = [[self servicesUri] stringByAppendingFormat:@"/%@", valueUri];
    NSURL *url = [NSURL URLWithString:uri];
    
    NSLog(@"url : %@",url);
    NSData *requestData = nil;
    
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypeGET payload:requestData];
}


- (NSURLRequest *)urlRequestForServiceParameterUpdateValue:(NSString *)valueUri value:(NSString *)value {
    
    NSString *uri = [[self servicesUri] stringByAppendingFormat:@"/%@", valueUri];
    NSURL *url = [NSURL URLWithString:uri];
    NSData *requestData = [value dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSLog(@"url : %@",url);
    return [self urlRequestForURL:url httpMethodType:HTTPMethodTypePUT payload:requestData];
}

@end
