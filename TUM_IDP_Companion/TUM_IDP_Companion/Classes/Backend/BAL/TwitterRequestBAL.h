//
//  TwitterRequestBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"
#import "SocialAccountRequestBAL.h"

@interface TwitterRequestBAL : SocialAccountRequestBAL

- (void)accessAccountWithHandler:(RequestBALHandler)handler;

@end
