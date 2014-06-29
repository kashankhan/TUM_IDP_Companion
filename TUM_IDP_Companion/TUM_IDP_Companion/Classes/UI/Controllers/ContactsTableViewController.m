//
//  ContactsTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "SWRevealViewController.h"
#import "ContactsDAL.h"
#import "ContantTableViewCell.h"

@interface ContactsTableViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;

@end

@implementation ContactsTableViewController

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
    
    [self configureNavigationBarItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadContacts) name:kAuthorizationUpdateNotification object:nil];
    [self loadContacts];
   
}


- (void)configureNavigationBarItems {
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)loadContacts {

    if (!_contactDal) {
        _contactDal = [ContactsDAL new];
    }
    _items = [[_contactDal addressBook] mutableCopy];
    
    [self.tableView reloadData];
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

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    return _items[indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdentifierDefaultCell" forIndexPath:indexPath];
    
    // Configure the cell...

    ABContact *contact =  [self objectAtIndexPath:indexPath];
    cell.textLabel.text = contact.firstname;
    cell.imageView.image = contact.image;
    cell.textLabel.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark - Table view delegate method

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


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

@end
