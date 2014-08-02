//
//  UIViewController+ProgressHUD.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "UIViewController+ProgressHUD.h"
#import "ProgressHUD.h"

@implementation UIViewController (ProgressHUD)

- (void)showProgressHud:(ProgressHudType)progressHudType title:(NSString *)title interaction:(BOOL)interaction {
    switch (progressHudType) {
        case ProgressHudSuccess:
            [ProgressHUD showSuccess:title Interaction:interaction];
            break;
            
        case ProgressHudError:
            [ProgressHUD showError:title Interaction:interaction];
            break;
            
        case ProgressHudNormal:
        default:
            [ProgressHUD show:title Interaction:interaction];
            break;
    }
    
}

- (void)dismissProgressHud {

    [ProgressHUD dismiss];

}
@end
