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
#import "LocationBookmark.h"
#import "MapViewAnnotation.h"

@interface MapViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *menuBarButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *tripLocations;
@property (nonatomic, weak) NSMutableDictionary *lastSelectedTripInfo;
@property (nonatomic, strong) LocationBookmark *selectedLocationBookmark;
@end

@implementation MapViewController

static NSString *kSegueIdentiferPushSearchLocationTableViewController = @"SegueIdentiferPushSearchLocationTableViewController";
#define METERS_PER_MILE 1609.344

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
    [self subscribteNotifications];
    
    [self setTitle:NSLS_MAPS];
    
}

- (void)configureNavigationBarItems {
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)subscribteNotifications {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLocationDidSelectNotification:) name:UIUserLocationDidSelectNotification object:nil];
}

- (void)setUpTripPlannerTableViewControllerHandler {
 
    NSString *destinationKey = NSLS_DESTINATION;
    id object = (self.selectedLocationBookmark) ? self.selectedLocationBookmark : [NSNull null];
    _tripLocations = [@[[@{destinationKey: object} mutableCopy]] mutableCopy];
    
   TripPlannerTableViewController *controller = (TripPlannerTableViewController *)[self.childViewControllers lastObject];
    [controller setLocationBookmarks:_tripLocations];
    [controller.tableView reloadData];
    
    controller.tripPlannerTableViewControllerDidSelectObjectHandler = ^(NSMutableDictionary * object){
   
        [self setLastSelectedTripInfo:object];
        [self performSegueWithIdentifier:kSegueIdentiferPushSearchLocationTableViewController sender:self];
    };
}

- (void)setTripInfoInTripLocation:(LocationBookmark *)locationBookmark  {

    NSString *key = [[self.lastSelectedTripInfo allKeys] lastObject];
    NSInteger index =  [_tripLocations indexOfObject:self.lastSelectedTripInfo];
    
    [self.lastSelectedTripInfo setValue:locationBookmark forKey:key];
    [_tripLocations replaceObjectAtIndex:index withObject:self.lastSelectedTripInfo];
    
    TripPlannerTableViewController *controller = (TripPlannerTableViewController *)[self.childViewControllers lastObject];
    
    
    [controller.tableView reloadData];
}


- (void)addLocationToMapView:(LocationBookmark *)locationBookmark {

    MapViewAnnotation *annotationView = [self locationBookmarkToMapAnnotationView:self.selectedLocationBookmark];
    [self.mapView removeAnnotation:annotationView];
    annotationView = [self locationBookmarkToMapAnnotationView:locationBookmark];
    [self setTripInfoInTripLocation:locationBookmark];
    [self.mapView addAnnotation:annotationView];
}

- (MapViewAnnotation *)locationBookmarkToMapAnnotationView:(LocationBookmark *)locationBookmark {

    //Create coordinates from the latitude and longitude values
    CLLocationCoordinate2D coord;
    coord.latitude = locationBookmark.latitude.doubleValue;
    coord.longitude = locationBookmark.longitude.doubleValue;
    
    MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:locationBookmark.name coordinate:coord];
    
    return annotation;
}
- (void)zoomToLocation {
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 13.03297;
    zoomLocation.longitude= 80.26518;
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 7.5*METERS_PER_MILE,7.5*METERS_PER_MILE);
    [self.mapView setRegion:viewRegion animated:YES];
    
    [self.mapView regionThatFits:viewRegion];
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
    else if ([segue.identifier isEqualToString:kSegueIdentiferPushSearchLocationTableViewController]) {
    
        SearchLocationTableViewController *controller = (SearchLocationTableViewController *)[segue destinationViewController];
        [controller setMapView:self.mapView];
    }//else if
}

#pragma mark -Notification
- (void)userLocationDidSelectNotification:(NSNotification *)notificaiton {

    [self addLocationToMapView:notificaiton.object];
    [self.navigationController popToViewController:self animated:YES];

}
@end
