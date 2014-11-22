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
#import "MapRouteSettingViewController.h"
#import "SettingsDAL.h"
#import "VMAddressServiceParameterBAL.h"


@interface MapViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

@property (nonatomic, weak) IBOutlet UIBarButtonItem *menuBarButton;
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *tripLocations;
@property (nonatomic, weak) NSMutableDictionary *lastSelectedTripInfo;
@property (nonatomic, strong) LocationBookmark *selectedLocationBookmark;
@property (nonatomic, strong) RouteEnergySetting *routeSetting;
@property (nonatomic, strong) VMAddressServiceParameterBAL *addressServiceParameterBAL;

@end

@implementation MapViewController

static NSString *kSegueIdentiferPushSearchLocationTableViewController = @"SegueIdentiferPushSearchLocationTableViewController";

static NSString *kSegueIdentiferPushMapRouteSettingViewController = @"SegueIdentiferPushMapRouteSettingViewController";

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
    
    [self syncServices];
    
    SettingsDAL *settingDAL = [SettingsDAL new];
    self.routeSetting = [settingDAL selectedRouteEnergySetting];
    
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

    [self.mapView removeAnnotations:self.mapView.annotations];
    MapViewAnnotation *annotationView = [self locationBookmarkToMapAnnotationView:locationBookmark];
  
    [self setTripInfoInTripLocation:locationBookmark];
    [self updateAdress:locationBookmark];
    
    NSMutableArray *annotations = [@[] mutableCopy];
    [annotations addObject:self.mapView.userLocation];
    
    if (locationBookmark) {
        [annotations addObject:annotationView];
    }
    
    [self.mapView addAnnotations:annotations];
    [self zoomToLocation];
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
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}


#pragma mark - Address Service BAL methods
- (void)syncServices {
    
    if (!self.addressServiceParameterBAL) {
        self.addressServiceParameterBAL = [VMAddressServiceParameterBAL new];
    }
    
    [self showProgressHud:ProgressHudNormal title:NSLS_PLEASE_WAIT interaction:YES];
    [self.addressServiceParameterBAL sendRequestForServices:^(id response, NSError *error) {
        
        [self dismissProgressHud];
    }];
}

- (void)updateAdress:(LocationBookmark *)locationBookmark {

    [self showProgressHud:ProgressHudNormal title:NSLS_PLEASE_WAIT interaction:YES];
    [self.addressServiceParameterBAL updateDestination:locationBookmark handler:^(id response, NSError *error) {
        
        [self dismissProgressHud];
    }];
}

- (void)updateRouteSetting:(RouteEnergySetting *)routeSetting {
    
    [self showProgressHud:ProgressHudNormal title:NSLS_PLEASE_WAIT interaction:YES];
    [self.addressServiceParameterBAL updateRouteSetting:routeSetting.parameter handler:^(id response, NSError *error) {
        
        [self dismissProgressHud];
    }];
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
    else if ([segue.identifier isEqualToString:kSegueIdentiferPushMapRouteSettingViewController]) {
        
        MapRouteSettingViewController *controller = (MapRouteSettingViewController *)[segue destinationViewController];
        controller.defaultOption = self.routeSetting;
        controller.selectionTableViewControllerDidSelectObjectHandler = ^(id object) {
            
            self.routeSetting = object;
            [self updateRouteSetting:self.routeSetting];
        };
    }//else if
}

#pragma mark -Notification
- (void)userLocationDidSelectNotification:(NSNotification *)notificaiton {

    [self addLocationToMapView:notificaiton.object];
    [self.navigationController popToViewController:self animated:YES];

}
@end
