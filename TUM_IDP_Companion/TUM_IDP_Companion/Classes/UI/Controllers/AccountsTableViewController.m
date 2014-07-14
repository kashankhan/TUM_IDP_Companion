//
//  AccountsTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "AccountsTableViewController.h"
#import "SWRevealViewController.h"
#import "UIImageView+WebCache.h"
#import "iHasApp.h"

@interface AccountsTableViewController ()

@property (nonatomic, strong) iHasApp *detectionObject;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;

@end

NSString *kAppIdKey = @"trackId";
NSString *kAppNameKey = @"trackName";

@implementation AccountsTableViewController

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
    
    _items = [@[] mutableCopy];
    self.detectionObject = [[iHasApp alloc] init];
    
    [self detectApps];
    
    [self configureNavigationBarItems];

}

- (void)configureNavigationBarItems {
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)addAppsInItems:(NSArray *)apps {

    NSString *facebookIdentifier = @"284882215";
    NSString *facebookMessengerIdentifier = @"454638411";
    NSString *whatsappIdentifier = @"310633997";
    NSString *skypIdentifier = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? @"442012681" : @"304878510";
    NSString *appId = @"";
    
    NSArray *appIdentifiers = @[facebookIdentifier, facebookMessengerIdentifier, whatsappIdentifier, skypIdentifier];
 
    for (NSDictionary *appInfo in apps) {
        appId = [[appInfo objectForKey:kAppIdKey] description];
        if ([appIdentifiers containsObject:appId] && ![_items containsObject:appInfo]) {
            [_items addObject:appInfo];
        }
    }

    [self.tableView reloadData];
}

- (void)removeAllItems {

    [_items removeAllObjects];
    [self.tableView reloadData];
}
- (id)objectAtIndexPath:(NSIndexPath *)indexPath {

    return _items[indexPath.row];
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
    return [_items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdentifierDefaultCell" forIndexPath:indexPath];
    
    // Configure the cell...
    NSDictionary *appInfo = [self objectAtIndexPath:indexPath];
    
    NSString *trackName = [appInfo objectForKey:kAppNameKey];
    NSString *trackId = [[appInfo objectForKey:kAppIdKey] description];
    //NSString *artworkUrl60 = [appDictionary objectForKey:@"artworkUrl60"];
    
    NSString *iconUrlString = [appInfo objectForKey:@"artworkUrl512"];
    NSArray *iconUrlComponents = [iconUrlString componentsSeparatedByString:@"."];
    NSMutableArray *mutableIconURLComponents = [[NSMutableArray alloc] initWithArray:iconUrlComponents];
    [mutableIconURLComponents insertObject:@"128x128-75" atIndex:mutableIconURLComponents.count-1];
    iconUrlString = [mutableIconURLComponents componentsJoinedByString:@"."];
    
    cell.textLabel.text = trackName;
    cell.detailTextLabel.text = trackId;
    
    [cell.imageView setImageWithURL:[NSURL URLWithString:iconUrlString]
                   placeholderImage:[UIImage imageNamed:@"placeholder-icon"]];
    return cell;
}

#pragma mark - Navigation
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}

#pragma mark - iHasApp methods

- (void)detectApps
{
    if ([UIApplication sharedApplication].networkActivityIndicatorVisible) {
        return;
    }

    [self.detectionObject detectAppDictionariesWithIncremental:^(NSArray *appDictionaries) {
        
        [self addAppsInItems:appDictionaries];
    } withSuccess:^(NSArray *appDictionaries) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        [self addAppsInItems:appDictionaries];
    } withFailure:^(NSError *error) {
        
        [self removeAllItems];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:error.localizedDescription
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
