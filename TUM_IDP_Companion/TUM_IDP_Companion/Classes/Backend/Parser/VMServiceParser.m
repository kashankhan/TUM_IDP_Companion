//
//  VMServiceParser.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 27/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceParser.h"
#import "VMServiceDAL.h"

@interface VMServiceParser () {
    
    VMServiceDAL *_serviceDAL;
}


@end

@implementation VMServiceParser

- (instancetype)init {
    
    self  = [super init];
    
    _serviceDAL = [VMServiceDAL new];
    
    return self;
}

- (void)dealloc {
    
    [_serviceDAL saveContext];
}

- (id)parseServices:(id)object {
    
    NSString *servicesKey = @"services";

    NSMutableArray *services = [@[] mutableCopy];
    for (NSDictionary *serviceInfo in [object valueForKey:servicesKey]) {
       [services addObject:[self parseService:serviceInfo]];
    }
    

    return services;
}

- (id)parseService:(id)object {
    
    NSString *parametersKey = @"parameters";
    NSString *nameKey = @"name";
    
    NSString *serviceName = [object valueForKey:nameKey];
    NSArray *parameters = [object valueForKey:parametersKey];
   
    Service *service = [_serviceDAL service:serviceName];
    service.name = serviceName;
    
    for (NSDictionary *parameterInfo in parameters) {
        [service addParametersObject:[self parseParameter:parameterInfo]];
    }
    
    return service;
}

- (id)parseParameter:(id)object {
    
    NSString *typeKey = @"type";//numeric",
    NSString *lowerBoundKey = @"lowerBound";//lowerBound":0.0,
    NSString *upperBoundKey = @"upperBound";//":50.0,
    NSString *stepSizeKey = @"stepSize";//":0.01,
    NSString *unitSymbolKey = @"unitSymbol";//":" km",
    NSString *readOnlyKey = @"readOnly";//":true,
    NSString *nameKey = @"name";//:"Distanz",
    NSString *linksKey = @"links";
    NSString *statesKey = @"states";
    NSUInteger index = 1;
    
    NSString *type = [object valueForKey:typeKey];
    NSNumber *lowerBound = [object valueForKey:lowerBoundKey];
    NSNumber *upperBound = [object valueForKey:upperBoundKey];
    NSNumber *stepSize = [object valueForKey:stepSizeKey];
    NSString *unitSymbol = [object valueForKey:unitSymbolKey];
    NSNumber *readOnly = [object valueForKey:readOnlyKey];
    NSString *name = [object valueForKey:nameKey];
    NSDictionary *linkInfo = [object valueForKey:linksKey];
    NSArray *states = [object valueForKey:statesKey];
    
    Parameter *parameter = [_serviceDAL parameter:name];
    parameter.type = type;
    parameter.lowerBound = lowerBound;
    parameter.upperBound = upperBound;
    parameter.stepSize = stepSize;
    parameter.unitSymbol = unitSymbol;
    parameter.readOnly = readOnly;
    parameter.name = name;
    
    parameter.link = [self parseLink:linkInfo];
    
    for (NSString *name in states) {
        [parameter addStatesObject:[self parseState:name index:index]];
        index ++;
    }
    
    return parameter;
}

- (id)parseLink:(id)object {
    
    NSString *subscriptionKey = @"subscription";
    NSString *valueKey = @"value";
    
    NSString *subscription = [object valueForKey:subscriptionKey];
    NSString *value =[object valueForKey:valueKey];
    
    Link *link = [_serviceDAL link:subscription];
    link.subscription = subscription;
    link.value = value;
    
    return link;
}

- (id)parseState:(id)name index:(NSUInteger)index {
    
    State *state = [_serviceDAL state:name];
    state.name = name;
    state.index = @(index);
    
    return state;

}
@end
