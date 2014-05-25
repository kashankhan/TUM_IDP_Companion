//
//  SocialAccountRequestBAL.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "RequestBAL.h"
#import <Accounts/Accounts.h>

@interface SocialAccountRequestBAL : RequestBAL

@property (nonatomic, strong, readonly) ACAccountStore *accountStore;

- (void)accessAccount:(NSString *)typeIdentifier options:(NSDictionary *)options WithHandler:(RequestBALHandler)handler;
@end
