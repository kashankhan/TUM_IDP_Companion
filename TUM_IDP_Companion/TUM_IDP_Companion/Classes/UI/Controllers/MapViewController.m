//
//  MapViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 25/05/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "MapViewController.h"
#import "SWRevealViewController.h"
#import <MapKit/MapKit.h>
#import "RequestHandler.h"

@interface MapViewController () <UISearchDisplayDelegate, UISearchBarDelegate> {

    RequestHandler *_reqeustHandler;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) MKLocalSearch *localSearch;
@property (strong, nonatomic) MKLocalSearchResponse *searchResponse;
@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureViewSettings];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private methods
- (void)configureViewSettings {
    
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    _reqeustHandler = [RequestHandler new];
    [self.searchDisplayController setDelegate:self];
    [self configureNavigationBarItems];
}

- (void)configureNavigationBarItems {
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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


#pragma mark - UISearchBar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // Cancel any previous searches.
    [self.localSearch cancel];
    
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
    }];
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.searchResponse.mapItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifierCell = @"IdentifierCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifierCell];
    }
    
    MKMapItem *item = self.searchResponse.mapItems[indexPath.row];
    
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchDisplayController setActive:NO animated:YES];
    
    MKMapItem *item = self.searchResponse.mapItems[indexPath.row];
    CLLocationCoordinate2D coordinate = item.placemark.location.coordinate;
    [self.mapView addAnnotation:item.placemark];
    [self.mapView selectAnnotation:item.placemark animated:YES];
    
    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    
    NSDictionary *params = @{@"latitude": [NSNumber numberWithLong:coordinate.latitude], @"longitude": [NSNumber numberWithLong:coordinate.longitude]};
    [_reqeustHandler sendRequest:RequestTypeAccessGreenNearestVertice params:params handler:^(id response, NSError *error) {
        
        NSLog(@" response : %@", response);
        NSLog(@" error : %@", [error description]);
        
    } ];
    
}

@end
