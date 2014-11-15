//
//  VMServiceDAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseDAL.h"
#import "Parameter.h"
#import "Service.h"
#import "Link.h"
#import "State.h"

@interface VMServiceDAL : BaseDAL

- (Service *)service:(NSString *)name;
- (Parameter *)parameter:(NSString *)name;
- (Link *)link:(NSString *)subscription;
- (State *)state:(NSString *)name;
- (NSArray *)services;

@end
