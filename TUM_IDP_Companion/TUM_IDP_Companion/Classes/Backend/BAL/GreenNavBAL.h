//
//  GreenNavBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 01/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"

typedef NS_ENUM(NSUInteger, GreenNavTurnType) {
    
    GreenNavTurnTypeNoTurn              = 0,
    GreenNavTurnTypeStraight            = 1,
    GreenNavTurnTypeLeftTurn            = 2,
    GreenNavTurnTypeRightTurn           = 3,
    GreenNavTurnTypeSlightLeftTurn      = 4,
    GreenNavTurnTypeSlightRightTurn     = 5,
    GreenNavTurnTypeSharpLeftTurn       = 6,
    GreenNavTurnTypeSharpRightTurn      = 7,
    GreenNavTurnTypeRoundAbout          = 20,
    GreenNavTurnTypeLeaveAbout          = 21
};

@interface GreenNavBAL : RequestBAL

- (void)sendTestVerticeSerivce:(RequestBALHandler)handler;
- (void)sendTestVerticeNearestSerivce:(RequestBALHandler)handler;
- (void)sendTestVehicles:(RequestBALHandler)handler;
- (void)sendTestVehiclesSam:(RequestBALHandler)handler;
- (void)sendTestVehiclesSamRoutes:(RequestBALHandler)handler;
- (void)sendTestVehiclesSamRoutesRate:(RequestBALHandler)handler;

@end
