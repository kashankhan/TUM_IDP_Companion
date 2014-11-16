//
//  VMAddressServiceParameterBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 15/11/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMAddressServiceParameterBAL.h"

@implementation VMAddressServiceParameterBAL

- (NSString *)subscriptionUri:(AddressType)addressType {

    NSString *uri = [NSString stringWithFormat:@"navigation/parameters/%@/subscription", [self valueForAddressType:addressType]];
    return uri;
}

- (NSString *)updateValueUri:(AddressType)addressType {
    
    NSString *uri = [NSString stringWithFormat:@"navigation/parameters/%@", [self valueForAddressType:addressType]];
    return uri;
}

- (NSString *)valueForAddressType:(AddressType)addressType {
 
    NSString *value = @"";
    
    switch (addressType) {
            
        case AddressTypeHome:
            value = @"homeAddress";
            break;
            
        case AddressTypeOffice:
            value = @"workAddress";
            break;
            
        case AddressTypeFavorite1:
            value = @"favorite1Address";
            break;
            
        case AddressTypeFavorite2:
            value = @"favorite2Address";
            break;
            
        case AddressTypeFavorite3:
            value = @"favorite3Address";
            break;
        
        case AddressTypeFavorite4:
            value = @"favorite4Address";
            break;
            
        case AddressTypeFavorite5:
            value = @"favorite5Address";
            break;
            
        default:
            break;
    }
    
    return value;
}

- (void)updateAddress:(NSString *)address addressType:(AddressType)addressType handler:(RequestBALHandler)handler {
    
    NSDictionary *params =  @{kParameterUpdatedValueKey : address ,
                              kParameterValueUriKey : [self updateValueUri:addressType]};
    
    [self sendRequestForServiceParameterUpdateValue:params handler:handler];
}
@end
