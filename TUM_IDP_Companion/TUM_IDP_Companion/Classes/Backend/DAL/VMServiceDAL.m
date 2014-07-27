//
//  VMServiceDAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceDAL.h"
#import "Parameter.h"
#import "Service.h"
#import "Link.h"

@implementation VMServiceDAL

- (Service *)service:(NSString *)name {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    return (Service *)[self getObjectWithEntity:[Service class] withPredicate:predicate createNewIfNotFound:YES];
    
}

- (Parameter *)parameter:(NSString *)name {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    return (Parameter *)[self getObjectWithEntity:[Parameter class] withPredicate:predicate createNewIfNotFound:YES];
    
}

- (Link *)link:(NSString *)subscription {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subscription = %@", subscription];
    return (Link *)[self getObjectWithEntity:[Link class] withPredicate:predicate createNewIfNotFound:YES];
    
}

- (NSArray *)services {
    
    return [Service MR_findAll];
}

@end
