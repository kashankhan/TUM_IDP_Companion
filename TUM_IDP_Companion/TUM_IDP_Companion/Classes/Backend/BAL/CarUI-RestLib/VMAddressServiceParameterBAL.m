//
//  VMAddressServiceParameterBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 15/11/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMAddressServiceParameterBAL.h"

@implementation VMAddressServiceParameterBAL

static NSString *const kAddressUriKey           = @"AddressUriKey";
static NSString *const kAddressAliasUriKey      = @"AddressAliasUriKey";
static NSString *const kAddressLatitudeUriKey   = @"AddressLatitudeUriKey";
static NSString *const kAddressLongitudeUriKey  = @"AddressLongitudeUriKey";

- (NSString *)subscriptionUri:(NSString *)uri {
    
    uri = [NSString stringWithFormat:@"navigation/parameters/%@/subscription", uri];
    return uri;
}

- (NSString *)updateValueUri:(NSString *)uri {
    
    uri = [NSString stringWithFormat:@"navigation/parameters/%@", uri];
    return uri;
}


- (NSDictionary *)updateValueUriInfo:(AddressType)addressType {
    
    NSString *value = nil;
    
    switch (addressType) {
            
        case AddressTypeHome:
            value = @"home";
            break;
            
        case AddressTypeOffice:
            value = @"work";
            break;
            
        case AddressTypeFavorite1:
            value = @"favorite1";
            break;
            
        case AddressTypeFavorite2:
            value = @"favorite2";
            break;
            
        case AddressTypeFavorite3:
            value = @"favorite3";
            break;
            
        case AddressTypeFavorite4:
            value = @"favorite4";
            break;
            
        case AddressTypeFavorite5:
            value = @"favorite5";
            break;
            
        default:
            break;
    }
    
    
    NSString *addressUri = [value stringByAppendingString:@"Address"];
    NSString *aliasUri = [value stringByAppendingString:@"Name"];
    NSString *latitudeUri = [value stringByAppendingString:@"Latitude"];
    NSString *longitudeUri = [value stringByAppendingString:@"Longitude"];
    
    NSDictionary *uriInfo = @{kAddressUriKey : addressUri,
                              kAddressAliasUriKey : aliasUri,
                              kAddressLatitudeUriKey : latitudeUri,
                              kAddressLongitudeUriKey : longitudeUri};
    
    return uriInfo;
}

- (void)updateAddress:(LocationBookmark *)locationBookmark addressType:(AddressType)addressType handler:(RequestBALHandler)handler {
    
    NSDictionary *uriInfo = [self updateValueUriInfo:addressType];
    NSString *uri = nil;
    NSString *value = @"";
    
    for (NSString *uriKey in [uriInfo allKeys]) {
        
        uri = [self updateValueUri:[uriInfo valueForKey:uriKey]];
        
        if ([uriKey isEqualToString:kAddressUriKey]) {
            value = locationBookmark.address;
        }
        else if ([uriKey isEqualToString:kAddressAliasUriKey]) {
            value = locationBookmark.name;
        }
        else if ([uriKey isEqualToString:kAddressLatitudeUriKey]) {
             value = [locationBookmark.latitude stringValue];
        }
        else if ([uriKey isEqualToString:kAddressLongitudeUriKey]) {
            value = [locationBookmark.longitude stringValue];
        }
        
        NSDictionary *params =  @{kParameterUpdatedValueKey : value,
                                  kParameterValueUriKey : uri};
        
        [self sendRequestForServiceParameterUpdateValue:params handler:handler];
    }
    

}

- (void)updateDestination:(LocationBookmark *)locationBookmark handler:(RequestBALHandler)handler {
    
    NSString *value = [NSString stringWithFormat:@"{address:%@, latitude:%@, longitude:%@, name:%@}", locationBookmark.address, locationBookmark.latitude, locationBookmark.longitude, locationBookmark.name];
    NSString *uri = @"navigation/parameters/destinationAddress";
    
    NSDictionary *params =  @{kParameterUpdatedValueKey : value,
                              kParameterValueUriKey : uri};
    
    [self sendRequestForServiceParameterUpdateValue:params handler:handler];

}

- (void)updateRouteSetting:(NSString *)routeSetting handler:(RequestBALHandler)handler {

    NSString *value = routeSetting;
    NSString *uri = @"navigation/parameters/routingType";
    
    NSDictionary *params =  @{kParameterUpdatedValueKey : value,
                              kParameterValueUriKey : uri};
    
    [self sendRequestForServiceParameterUpdateValue:params handler:handler];

}
@end
