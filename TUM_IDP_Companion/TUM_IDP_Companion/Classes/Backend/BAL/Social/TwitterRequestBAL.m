//
//  TwitterRequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "TwitterRequestBAL.h"
#import <Twitter/Twitter.h>

@implementation TwitterRequestBAL

- (void)accessAccountWithHandler:(RequestBALHandler)handler {

    NSDictionary *options = nil;
    [self accessAccount:ACAccountTypeIdentifierTwitter options:options WithHandler:^(id response, NSError *error) {
        handler (response, error);
    }];

}
@end
