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
#import "SearchLocationTableViewController.h"
#import "TripPlannerTableViewController.h"

@interface MapViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *menuBarButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) MKLocalSearch *localSearch;
@property (nonatomic, strong) MKLocalSearchResponse *searchResponse;

@property (nonatomic, strong) NSMutableArray *tripLocations;

@property (nonatomic, weak) NSMutableDictionary *lastSelectedTripInfo;
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
    
    [self setUpTripPlannerTableViewControllerHandler];
    
    [self configureNavigationBarItems];
    
}

- (void)configureNavigationBarItems {
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)setUpTripPlannerTableViewControllerHandler {
 
    NSString *destinationKey = NSLS_DESTINATION;
    
    _tripLocations = [@[[@{destinationKey: [NSNull null]} mutableCopy]] mutableCopy];
    
   TripPlannerTableViewController *controller = (TripPlannerTableViewController *)[self.childViewControllers lastObject];
    [controller setTripLocations:_tripLocations];
    [controller.tableView reloadData];
    
    controller.tripPlannerTableViewControllerDidSelectObjectHandler = ^(NSMutableDictionary * object){
   
        [self setLastSelectedTripInfo:object];
        [self performSegueWithIdentifier:@"SegueIdentiferSearchLocationTableViewController" sender:self];
    };
}

- (void)setTripInfoInTripLocations:(MKMapItem *)mapItem  {

    NSString *key = [[self.lastSelectedTripInfo allKeys] lastObject];
    NSInteger index =  [_tripLocations indexOfObject:self.lastSelectedTripInfo];
    
    [self.lastSelectedTripInfo setValue:mapItem forKey:key];
    [_tripLocations replaceObjectAtIndex:index withObject:self.lastSelectedTripInfo];
    
    TripPlannerTableViewController *controller = (TripPlannerTableViewController *)[self.childViewControllers lastObject];
    
    
    [controller.tableView reloadData];
}


- (IBAction)performSearchRoute:(id)sender {
}

#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id) sender
{
    if ([segue isKindOfClass:[SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }//if
    else if ([segue.identifier isEqualToString:@"SegueIdentiferSearchLocationTableViewController"]) {
    
        SearchLocationTableViewController *controller = (SearchLocationTableViewController *)[segue destinationViewController];
        [controller setMapView:self.mapView];
        controller.searchLocationTableViewControllerHandler = ^(MKMapItem *mapItem) {
        
            [self setTripInfoInTripLocations:mapItem];
        };
    }//else if
}
@end
