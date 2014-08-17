//
//  SlideMenuTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SlideMenuTableViewController.h"
#import "SWRevealViewController.h"

@interface SlideMenuTableViewController ()

@end

@implementation SlideMenuTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureViewSettings];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods
- (void)configureViewSettings {
 
    NSString *accounts = NSLS_ACCOUNTS;
    NSString *maps = NSLS_MAPS;
    NSString *contants = NSLS_CONTACTS;
    NSString *music = NSLS_MUSIC;
    NSString *settings = NSLS_SETTINGS;
    
    _menuItems =  @[  @{ @"SegueIdentiferPushAccountsViewController" :  accounts},
                      @{ @"SegueIdentiferPushMapsViewController" : maps},
                      @{ @"SegueIdentiferPushContactsViewController" : contants},
                      @{ @"SegueIdentiferSelectionTableViewController" : music},
                      @{ @"SegueIdentiferPushSettingsViewController" : settings}
                      ];
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
  return [_menuItems objectAtIndex:indexPath.row];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdentifierDefaultCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *itemInfo = [self objectAtIndexPath:indexPath];
    cell.textLabel.text = [[itemInfo allValues] lastObject];
    return cell;
}


#pragma mark - Table view delegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *itemInfo = [self objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:[[itemInfo allKeys] lastObject] sender:self];
    
}


#pragma mark - Navigation
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    NSDictionary *itemInfo = [self objectAtIndexPath:indexPath];

    destViewController.title = [[[itemInfo allValues] lastObject] capitalizedString];
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

@end
