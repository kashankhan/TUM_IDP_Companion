//
//  MapViewAnnotation.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 05/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

-(id) initWithTitle:(NSString *) title coordinate:(CLLocationCoordinate2D)coordinate
{
    self =  [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
}

@end
