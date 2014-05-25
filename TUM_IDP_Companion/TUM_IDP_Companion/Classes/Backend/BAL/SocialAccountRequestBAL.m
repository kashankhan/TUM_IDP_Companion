//
//  SocialAccountRequestBAL.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SocialAccountRequestBAL.h"

@implementation SocialAccountRequestBAL

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        _accountStore = [[ACAccountStore alloc] init];
    }
    
    return self;
}

- (void)accessAccount:(NSString *)typeIdentifier options:(NSDictionary *)options WithHandler:(RequestBALHandler)handler {
    
    ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:typeIdentifier];
    [self.accountStore requestAccessToAccountsWithType:accountType options:options completion:^(BOOL granted, NSError *error) {
        NSArray *accounts = nil;
        if(granted) {
            accounts = [self.accountStore accountsWithAccountType:accountType];
            
        }//if
        handler (accounts, error);
    }];
    
}
@end
