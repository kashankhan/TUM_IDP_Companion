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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_contactDal saveContext];
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

    [self showProgressHud:ProgressHudNormal title:nil interaction:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Background work
        if (!_contactDal) {
            _contactDal = [ContactsDAL new];
            _items = [@[] mutableCopy];
            self.favoriteContactIdentiiers = [@[] mutableCopy];
            _addressBookContacts = [[_contactDal addressBook] mutableCopy];
            
            [self setContactsType:ContactsTypeAll];
        }
        
        NSArray *contacts = [self contacts];
        
        [_items setArray:[self transfromContactsIntoSection:contacts]];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update UI
            [self dismissProgressHud];
            [self.tableView reloadData];
        });
    });
}

- (NSArray *)transfromContactsIntoSection:(NSArray *)contacts {
   
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSArray *sectionTitles = [collation sectionTitles];
    NSMutableArray *sections = [@[] mutableCopy];
    
    NSPredicate *predicate = nil;
    NSArray *filterContacts = nil;
    for (NSString *title in sectionTitles) {
        predicate = [NSPredicate predicateWithFormat:@"self.firstname beginswith[c] %@", title];
        filterContacts = [contacts filteredArrayUsingPredicate:predicate];
        if (filterContacts) {
            [sections addObject:filterContacts];
        }
    }

    return sections;

}

- (NSArray *)contacts {
    
    [self.favoriteContactIdentiiers removeAllObjects];

    NSArray *allContacts = _addressBookContacts;
    NSMutableArray *favorites = [@[] mutableCopy];
    NSString *contactIdentifier = nil;
    Contact *saveContact = nil;

    for (ABContact *contact in allContacts) {
        contactIdentifier = [NSString stringWithFormat:@"%d", contact.recordID];
        saveContact = [_contactDal contact:contactIdentifier createNewIfNotFound:YES];
       
        if ([saveContact.favorite boolValue]) {
            [favorites addObject:contact];
            [self.favoriteContactIdentiiers addObject:contactIdentifier];
        }
    }

    return (self.contactsType == ContactsTypeFavorites) ? favorites : allContacts;
}


- (IBAction)segmentedControlValueDidChange:(id)sender {
    
    [self setContactsType:[self.segmentedControl selectedSegmentIndex]];
    [self loadContacts];
}

- (void)markContactAsFavorite:(BOOL)favorite identifier:(NSString *)identifier {

    Contact *contact =  [_contactDal contact:identifier createNewIfNotFound:YES];
    [contact setFavorite:@(favorite)];
    [contact setIdentifier:identifier];
    
    if (favorite) {
        [self.favoriteContactIdentiiers addObject:identifier];
    }
    else {
        [self.favoriteContactIdentiiers removeObject:identifier];
    }

}

#pragma mark - Table view data source
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    //we use sectionTitles and not sections
    return [[UILocalizedIndexedCollation currentCollation] sectionTitles];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //we use sectionTitles and not sections
    return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] count];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ([_items count]) ? [[_items objectAtIndex:section] count] : 0;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    BOOL showSection = ([_items count]) ? [[_items objectAtIndex:section] count] != 0 : NO;
    //only show the section title if there are rows in the section
    return (showSection) ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
}


- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *list = _items[indexPath.section];
    return list[indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdentifierDefaultCell" forIndexPath:indexPath];
    
    // Configure the cell...

    ABContact *contact =  [self objectAtIndexPath:indexPath];
    cell.titleLabel.text = [NSString  stringWithFormat:@"%@ %@", contact.firstname, ([contact.lastname isKindOfClass:[NSString class]] ? contact.lastname : @"")];
    cell.avatarImageView.image = contact.image;
    
    NSString *contactIdentifier = [NSString stringWithFormat:@"%d", contact.recordID];
    BOOL selected = [self.favoriteContactIdentiiers containsObject:contactIdentifier];
    [cell setFavoriteButtonSelected:selected];
    
    cell.eventHandler = ^(ContantTableViewCell *cell, id sender) {
       
        BOOL selected = ![self.favoriteContactIdentiiers containsObject:contactIdentifier];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        ABContact *contact =  [self objectAtIndexPath:indexPath];
        NSString *contactIdentifier = [NSString stringWithFormat:@"%d", contact.recordID];
        [self markContactAsFavorite:selected identifier:contactIdentifier];
        [cell setFavoriteButtonSelected:selected];
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
