//
//  GreenNavBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 01/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"

@interface GreenNavBAL : RequestBAL

- (void)sendTestVerticeSerivce:(RequestBALHandler)handler;
- (void)sendTestVerticeNearestSerivce:(RequestBALHandler)handler;
- (void)sendTestVehicles:(RequestBALHandler)handler;
- (void)sendTestVehiclesSam:(RequestBALHandler)handler;
- (void)sendTestVehiclesSamRoutes:(RequestBALHandler)handler;
- (void)sendTestVehiclesSamRoutesRate:(RequestBALHandler)handler;

@end
