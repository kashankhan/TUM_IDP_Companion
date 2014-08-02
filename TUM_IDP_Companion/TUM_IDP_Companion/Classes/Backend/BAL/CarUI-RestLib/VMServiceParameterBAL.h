//
//  VMServiceParameterBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 31/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "VMServiceRequestBAL.h"

extern NSString* const kParameterSubcribtionUriKey;
extern NSString* const kParameterValueUriKey;
extern NSString* const kParameterUpdatedValueKey;

@interface VMServiceParameterBAL : VMServiceRequestBAL

- (void)sendRequestForParameterValue:(id)params handler:(RequestBALHandler)handler;
- (void)sendRequestForServiceParameterUpdateValue:(id)params handler:(RequestBALHandler)handler;
- (void)sendRequestForSubscribeEvent:(id)params handler:(RequestBALHandler)handler;
@end
