//
//  DetailViewController.h
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 24/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
