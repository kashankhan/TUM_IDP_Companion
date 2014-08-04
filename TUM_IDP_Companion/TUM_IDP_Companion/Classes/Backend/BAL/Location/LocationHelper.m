//
//  LocationHelper.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "LocationHelper.h"

@implementation LocationHelper


+ (void)locationFromAddress:(NSString*)address handler:(LocationHelperHandler)locationHelperHandler {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        double latitude = 0, longitude = 0;
        NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        if (result) {
            NSScanner *scanner = [NSScanner scannerWithString:result];
            if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
                [scanner scanDouble:&latitude];
                if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                    [scanner scanDouble:&longitude];
                }
            }
        }
        
        if (locationHelperHandler) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CLLocationCoordinate2D center;
                center.latitude = latitude;
                center.longitude = longitude;
                locationHelperHandler (center);
            });

        }
   });
    
}
@end
