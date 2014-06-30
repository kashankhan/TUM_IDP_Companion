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


typedef NS_ENUM(NSUInteger, ContactsType) {
    
    ContactsTypeAll                     = 0,
    ContactsTypeFavorites               = 1
};

@interface ContactsTableViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (strong, nonatomic) NSMutableArray *favoriteContactIdentiiers;
@property (nonatomic) ContactsType contactsType;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

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
    
    [self.segmentedControl setTitle:NSLS_ALL forSegmentAtIndex:0];
    [self.segmentedControl setTitle:NSLS_FAVORITES forSegmentAtIndex:1];
    
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
        _items = [@[] mutableCopy];
        self.favoriteContactIdentiiers = [@[] mutableCopy];
        [self setContactsType:ContactsTypeAll];
    }
    
    [_items setArray:[self contacts]];
    
    [self.tableView reloadData];
}

- (NSArray *)contacts {

    NSArray *allContacts = [_contactDal addressBook];
    NSMutableArray *favorites = [@[] mutableCopy];
    NSString *contactIdentifier = nil;
    if (self.contactsType == ContactsTypeFavorites) {
        
        for (ABContact *contact in allContacts) {
            contactIdentifier = [NSString stringWithFormat:@"%d", contact.recordID];
            if ([self.favoriteContactIdentiiers containsObject:contactIdentifier]) {
                
                [favorites addObject:contact];
            }
        }
        
        allContacts = favorites;
    }
    
    return allContacts;
}

- (IBAction)segmentedControlValueDidChange:(id)sender {
    
    [self setContactsType:[self.segmentedControl selectedSegmentIndex]];
    [self loadContacts];
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
    cell.titleLabel.text = contact.firstname;
    cell.avatarImageView.image = contact.image;
    
    NSString *contactIdentifier = [NSString stringWithFormat:@"%d", contact.recordID];
    BOOL selected = [self.favoriteContactIdentiiers containsObject:contactIdentifier];
    [cell setFavoriteButtonSelected:selected];
    
    cell.eventHandler = ^(ContantTableViewCell *cell, id sender) {
       
        BOOL selected = [self.favoriteContactIdentiiers containsObject:contactIdentifier];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ABContact *contact =  [self objectAtIndexPath:indexPath];

        NSString *contactIdentifier = [NSString stringWithFormat:@"%d", contact.recordID];
        selected = [self.favoriteContactIdentiiers containsObject:contactIdentifier];
        
        if (selected) {
            
            [self.favoriteContactIdentiiers removeObject:contactIdentifier];
        }
        else {
            [self.favoriteContactIdentiiers addObject:contactIdentifier];
        }
        [cell setFavoriteButtonSelected:!selected];
    };
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
