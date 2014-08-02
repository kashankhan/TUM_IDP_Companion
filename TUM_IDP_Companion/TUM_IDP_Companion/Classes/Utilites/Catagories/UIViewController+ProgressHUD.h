//
//  UIViewController+ProgressHUD.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ProgressHudType) {
    ProgressHudNormal,
    ProgressHudSuccess,
    ProgressHudError
};

@interface UIViewController (ProgressHUD)

- (void)showProgressHud:(ProgressHudType)progressHudType title:(NSString *)title interaction:(BOOL)interaction;
- (void)dismissProgressHud;
@end
