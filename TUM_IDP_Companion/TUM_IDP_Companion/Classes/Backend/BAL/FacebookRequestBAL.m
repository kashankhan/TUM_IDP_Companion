//
//  FacebookRequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "FacebookRequestBAL.h"

@implementation FacebookRequestBAL

- (void)accessAccountWithHandler:(RequestBALHandler)handler {
    
    NSString *key = @"505280869573375";
    NSDictionary *options = @{
                              ACFacebookAppIdKey : key,
                              ACFacebookPermissionsKey : @[@"publish_stream"],
                              ACFacebookAudienceKey: ACFacebookAudienceEveryone
                              };


    [self accessAccount:ACAccountTypeIdentifierFacebook options:options WithHandler:^(id response, NSError *error) {
        handler (response, error);
    }];
    
}
@end
