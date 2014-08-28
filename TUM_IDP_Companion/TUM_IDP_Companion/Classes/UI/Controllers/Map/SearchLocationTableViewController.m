//
//  SearchLocationTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 08/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SearchLocationTableViewController.h"
#import "LocationBookmarksTableViewController.h"
#import "ContactsDAL.h"
#import "LocationBookmarkDAL.h"
#import "LocationHelper.h"

typedef NS_ENUM(NSUInteger, ScopeType) {
    
    ScopeTypePlaces                     = 0,
    ScopeTypeContacts                   = 1,
    ScopeTypeBookmarks                  = 2
};

@interface SearchLocationTableViewController () {

    ContactsDAL *_contactDal;
    LocationBookmarkDAL *_locationBookmarkDAL;
}
    
@property (strong, nonatomic) MKLocalSearch *localSearch;
@property (strong, nonatomic) MKLocalSearchResponse *searchResponse;
@property (strong, nonatomic) NSArray *contacts;
@property (strong, nonatomic) NSArray *contactsSearch;

@property (strong, nonatomic) NSArray *locationBookmarks;
@property (strong, nonatomic) NSArray *locationBookmarksSearch;

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

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self dismissProgressHud];
}

#pragma mark - Private methods
- (void)configureViewSettings {
    
    [self setTitle:NSLS_SEARCH_LOCATION];
    [self initializeDataSources];
}

- (void)initializeDataSources {
    
    _contactDal = [ContactsDAL new];
    self.contacts = [_contactDal addressBook];
    
    _locationBookmarkDAL = [LocationBookmarkDAL new];
    self.locationBookmarks = [_locationBookmarkDAL locationBookmarks];

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
        [self dismissProgressHud];
        
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
 
    }];
}


- (void)searchAddressBook:(UISearchBar *)searchBar {
    
    NSString *searchText = searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.firstname CONTAINS %@ || self.lastname CONTAINS %@", searchText, searchText];
    self.contactsSearch = [self.contacts filteredArrayUsingPredicate:predicate];

}

- (void)searchLocationBookmark:(UISearchBar *)searchBar {
   
    NSString *searchText = searchBar.text;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.name CONTAINS %@ || self.landmarkType CONTAINS %@", searchText, searchText];
    self.locationBookmarksSearch = [self.locationBookmarks filteredArrayUsingPredicate:predicate];

}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = nil;
    
    switch (self.scopeType) {
        
        case ScopeTypePlaces:
            object = self.searchResponse.mapItems[indexPath.row];
            break;
            
        case ScopeTypeContacts:
             object = self.contactsSearch[indexPath.row];
            break;
            
        case ScopeTypeBookmarks:
        default:
            object = self.locationBookmarksSearch[indexPath.row];
            break;
    }
    
    return object;
}

- (void)openLocationBookmarksViewController {

   LocationBookmarksTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationBookmarksTableViewController"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)sendNotificationForSelectedLocationBookmark:(LocationBookmark *)locationBookmark {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UIUserLocationDidSelectNotification object:locationBookmark];
}

- (void)sendNotificationForSelectedMapItem:(MKMapItem *)mapItem {
    
    LocationBookmark *locationBookmark = [_locationBookmarkDAL newLocationBookmark];
    locationBookmark.name = mapItem.name;
    locationBookmark.landmarkType = NSLS_OTHER;
    locationBookmark.latitude = @(mapItem.placemark.coordinate.latitude);
    locationBookmark.longitude = @(mapItem.placemark.coordinate.longitude);
    
    [self sendNotificationForSelectedLocationBookmark:locationBookmark];
}

- (void)sendNotificationForSelectedContact:(ABContact *)contact {
    
    NSArray *addresses = contact.addressArray;
   
    if (addresses) {
        id addressInfo = [addresses lastObject];
        NSString *city = [addressInfo valueForKey:@"City"];
        NSString *country = [addressInfo valueForKey:@"Country"];
        NSString *state = [addressInfo valueForKey:@"State"];
        NSString *street = [addressInfo valueForKey:@"Street"];
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@ %@", street, city, state, country];
        
        [self showProgressHud:ProgressHudNormal title:nil interaction:NO];
        
        [LocationHelper locationFromAddress:address handler:^(CLLocationCoordinate2D coordinate) {
            [self dismissProgressHud];
            
            ProgressHudType progressHudType = ProgressHudError;
            
            if (coordinate.latitude > 0 &&  coordinate.longitude > 0) {
                
                LocationBookmark *locationBookmark = [_locationBookmarkDAL newLocationBookmark];
                locationBookmark.name = address;
                locationBookmark.landmarkType = NSLS_OTHER;
                locationBookmark.latitude = @(coordinate.latitude);
                locationBookmark.longitude = @(coordinate.longitude);
                locationBookmark.favourite = @(YES);
                
                progressHudType = ProgressHudSuccess;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:UIUserLocationDidSelectNotification object:locationBookmark];
                
            }
            
            [self showProgressHud:progressHudType title:nil interaction:YES];
        }];
    }
    else {
        [self showProgressHud:ProgressHudError title:NSLS_ADDRESS_NOT_FOUNT interaction:YES];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger rows = 0;
    switch (self.scopeType) {
            
        case ScopeTypePlaces:
            rows = [self.searchResponse.mapItems count];
            break;
            
        case ScopeTypeContacts:
             rows = [self.contactsSearch count];
            break;
            
        case ScopeTypeBookmarks:
        default:
            rows = [self.locationBookmarksSearch count];
            break;
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"IdentifierCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifierCell];

    id object = [self objectAtIndexPath:indexPath];
    
    
    switch (self.scopeType) {
            
        case ScopeTypePlaces:
        {
            MKMapItem *item = object;
            cell.textLabel.text = item.name;
            cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
        }
            break;
            
        case ScopeTypeContacts:
        {
            ABContact *contact = object;
            cell.textLabel.text = [NSString  stringWithFormat:@"%@ %@", contact.firstname, ([contact.lastname isKindOfClass:[NSString class]] ? contact.lastname : @"")];            cell.detailTextLabel.text = nil;
            NSArray *addresses = contact.addressArray;
            if (addresses) {
                id address = [addresses lastObject];
                cell.detailTextLabel.text = [address valueForKey:@"Street"];
            }
        }
            break;
            
        case ScopeTypeBookmarks:
        default:
        {
            LocationBookmark *locationBookmark = object;
            cell.textLabel.text = locationBookmark.name;
            cell.detailTextLabel.text = locationBookmark.landmarkType;
        }
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id object = [self objectAtIndexPath:indexPath];
    switch (self.scopeType) {
            
        case ScopeTypePlaces:
            [self sendNotificationForSelectedMapItem:object];
            break;
            
        case ScopeTypeContacts:
            [self sendNotificationForSelectedContact:object];
            break;
        
        default:
            break;
    }
}

#pragma mark - UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  
    switch (self.scopeType) {
            
        case ScopeTypePlaces:
            [self searchPlaces:searchBar];
            break;
            
        case ScopeTypeContacts:
            [self searchAddressBook:searchBar];
            break;
            
        case ScopeTypeBookmarks:
        default:
            [self searchLocationBookmark:searchBar];
            break;
    }

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    switch (self.scopeType) {
            
        case ScopeTypePlaces:
            [self searchPlaces:searchBar];
            break;
            
        case ScopeTypeContacts:
            [self searchAddressBook:searchBar];
            break;
            
        case ScopeTypeBookmarks:
        default:
            [self searchLocationBookmark:searchBar];
            break;
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
