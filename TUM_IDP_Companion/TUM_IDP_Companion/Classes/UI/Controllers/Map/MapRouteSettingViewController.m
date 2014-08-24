//
//  MapRouteSettingViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 24/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "MapRouteSettingViewController.h"
#import "SettingsDAL.h"

@interface MapRouteSettingViewController () {
    
    SettingsDAL *_settingsDAL;
}

@end

@implementation MapRouteSettingViewController

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

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [_settingsDAL saveContext];
}

#pragma mark - Private methods
- (void)configureViewSettings {

    [self setTitle:NSLS_ROUTE_SETTINGS];
    
    _settingsDAL= [SettingsDAL new];
    self.options = [_settingsDAL routeSettings];
}

- (void)markAsDefaulfOption:(RouteEnergySetting *)routeEnergySetting {

    for (RouteEnergySetting *routeEnergySetting in self.options) {
        routeEnergySetting.selected = @(NO);
    }
    routeEnergySetting.selected = @(YES);
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell = @"IdentifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    cell.accessoryType = (self.defaultOption && [[self.options objectAtIndex:indexPath.row] isEqual:self.defaultOption]) ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    RouteEnergySetting *routeEnergySetting = self.options[indexPath.row];
    cell.textLabel.text = routeEnergySetting.name;
    
    return cell;
    
    
}

#pragma mark -UItableView Delegate methods.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //get the cell of last selected object.
    cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.options indexOfObject:self.defaultOption] inSection:0]];
    // remove the accessory view to last selected object.
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    // get the currnet selected cell
    cell = [tableView cellForRowAtIndexPath:indexPath];
    // set the currnet selected object to global _defaultText feild.
    RouteEnergySetting *routeEnergySetting = self.options[indexPath.row];
    [self setDefaultOption:routeEnergySetting];
    // set the check mark to the current object.
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    [self markAsDefaulfOption:routeEnergySetting];
    // send the delegate.
    if (self.selectionTableViewControllerDidSelectObjectHandler) {
        self.selectionTableViewControllerDidSelectObjectHandler(self.defaultOption);
    }//if
    
    // deselecting the last row
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
