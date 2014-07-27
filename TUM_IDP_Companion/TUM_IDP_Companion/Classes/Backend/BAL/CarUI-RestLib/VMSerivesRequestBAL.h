//
//  VMSerivesRequestBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 26/07/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"

@interface VMSerivesRequestBAL : RequestBAL

- (void)sendRequestForServices:(RequestBALHandler)handler;
@end
