//
//  SearchLocationTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 08/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SearchLocationTableViewController.h"
#import "ContactsDAL.h"
#import "LocationBookmarksTableViewController.h"

typedef NS_ENUM(NSUInteger, ScopeType) {
    
    ScopeTypePlaces                     = 0,
    ScopeTypeContacts                   = 1
};

@interface SearchLocationTableViewController () {

    ContactsDAL *_contactDal;
}
    
@property (strong, nonatomic) MKLocalSearch *localSearch;
@property (strong, nonatomic) MKLocalSearchResponse *searchResponse;
@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSArray *contactsSearch;
@property (nonatomic) ScopeType scopeType;

@end

@implementation SearchLocationTableViewController

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
    
    [self setTitle:NSLS_SEARCH_LOCATION];
    _contactDal = [[ContactsDAL alloc] init];
    self.contacts = [_contactDal addressBook];

}

- (void)searchPlaces:(UISearchBar *)searchBar {

    // Cancel any previous searches.
    [self.localSearch cancel];
    
    [self showProgressHud:ProgressHudNormal title:nil interaction:NO];
    // Perform a new search.
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.mapView.region;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [self.localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Map Error",nil)
                                        message:[error localizedDescription]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        if ([response.mapItems count] == 0) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Results",nil)
                                        message:nil
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles:nil] show];
            return;
        }
        
        [self setSearchResponse:response];
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        [self dismissProgressHud];
    }];
}


- (void)searchAddressBook:(UISearchBar *)searchBar {
    
    NSString *searchText = searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.firstname CONTAINS %@ || self.Street CONTAINS %@ ", searchText, searchText];
    self.contactsSearch = [self.contacts filteredArrayUsingPredicate:predicate];

}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = nil;
    if (self.scopeType == ScopeTypePlaces) {
        object = self.searchResponse.mapItems[indexPath.row];
    }
    else {
        object = self.contactsSearch[indexPath.row];
    }
    
    return object;
}

- (void)openLocationBookmarksViewController {

   LocationBookmarksTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationBookmarksTableViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return  (self.scopeType == ScopeTypePlaces)? [self.searchResponse.mapItems count] : [self.contactsSearch count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    id object = [self objectAtIndexPath:indexPath];
    
     [self dismissViewControllerAnimated:YES completion:^{
        if (self.searchLocationTableViewControllerHandler) {
            self.searchLocationTableViewControllerHandler(object);
        }
    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"IdentifierCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifierCell];

    id object = [self objectAtIndexPath:indexPath];
    if (self.scopeType == ScopeTypePlaces) {
        MKMapItem *item = object;
        cell.textLabel.text = item.name;
        cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    }
    else {
        ABContact *contact = object;
        cell.textLabel.text = [NSString  stringWithFormat:@"%@ %@", contact.firstname, contact.lastname];
        cell.detailTextLabel.text = nil;
        NSArray *addresses = contact.addressArray;
        if (addresses) {
            id address = [addresses lastObject];
            cell.detailTextLabel.text = [address valueForKey:@"Street"];
        }

    }
    
    return cell;
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if (self.scopeType == ScopeTypePlaces) {
        [self searchPlaces:searchBar];
    }
    else {
        [self searchAddressBook:searchBar];
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    if (self.scopeType == ScopeTypeContacts) {
        [self searchAddressBook:searchBar];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    
    [self setScopeType:selectedScope];
    [self.localSearch cancel];
    [searchBar setText:@""];
    
    [self.searchDisplayController.searchResultsTableView reloadData];

}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {

    [self openLocationBookmarksViewController];

}

@end
