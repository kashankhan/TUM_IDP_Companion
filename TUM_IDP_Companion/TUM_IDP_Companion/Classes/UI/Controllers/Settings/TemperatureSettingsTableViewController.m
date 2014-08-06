//
//  TemperatureSettingsTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 22/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "TemperatureSettingsTableViewController.h"
#import "SelectionTableViewController.h"
#import "SwitchTableViewCell.h"
#import "SettingsDAL.h"

@interface TemperatureSettingsTableViewController () {

    SettingsDAL *_settingsDAL;
    TemperatureSetting *_temperatureSetting;
    
}

@end

static NSString * kSettingNameKey = @"SettingName";
static NSString * kSettingDefualtOptionKey = @"SettingDefaultOption";
static NSString * kSettingOptionsKey = @"SettingOptions";
static NSString * kSettingSelectorKey = @"SettingSelector";
static NSString * kSettingCellIdentifierKey = @"SettingCellIdentifier";

static NSString * kIdentifierCell = @"IdentifierCell";
static NSString * kIdentifierSwitchCell = @"IdentifierSwitchCell";

@implementation TemperatureSettingsTableViewController

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
    [_settingsDAL saveContext];
}

#pragma mark - Private methods
- (void)configureViewSettings {
    
    _items = [@[] mutableCopy];
    
    _settingsDAL = [SettingsDAL new];
    _temperatureSetting = [_settingsDAL temperatureSetting];
    
    [self addTemperatureItem];
    [self addCoolingItem];
    [self addRecirculationItem];
}

- (void)addTemperatureItem {

    NSMutableArray *options = [@[]mutableCopy];
    NSString *option = @"";
    NSString *name = NSLS_TEMPERATURE;
    NSString *selector = @"openSelectionTableViewController";
    NSString *cellIdentifier = kIdentifierCell;
    for (CGFloat i = 16.0f; i <= 32.0; i+=0.5f) {
        option = [NSString stringWithFormat:@"%.1f °C", i];
        [options addObject:option];
    }//for
    
    NSString *defaultOption = (_temperatureSetting.temperature) ? _temperatureSetting.temperature : [options objectAtIndex:[options count]/2];
    _temperatureSetting.temperature = defaultOption;
    
    [self addItem:name options:options defaultOption:defaultOption selector:selector cellIdentifier:cellIdentifier];

}

- (void)addCoolingItem {
    
    NSArray *options = @[NSLS_OFF, NSLS_AUTOMATIC, NSLS_ECO, NSLS_EMISSION, NSLS_MANUAL];
    NSString *name = NSLS_COOLING;
    NSString *selector = @"openSelectionTableViewController";
    NSString *cellIdentifier = kIdentifierCell;
    
    NSString *defaultOption = (_temperatureSetting.cooling) ? _temperatureSetting.cooling : [options objectAtIndex:[options count]/2];
    _temperatureSetting.cooling = defaultOption;
    
    [self addItem:name options:options defaultOption:defaultOption selector:selector cellIdentifier:cellIdentifier];
    
}

- (void)addRecirculationItem {
    
    
    NSArray *options = @[[NSNumber numberWithBool:YES], [NSNumber numberWithBool:NO]];
    NSString *name = NSLS_RECIRCULATION;
    NSString *selector = @"";
    NSString *cellIdentifier = kIdentifierSwitchCell;
    NSNumber *defaultOption = (_temperatureSetting.recirculation) ? _temperatureSetting.recirculation : [options lastObject];
    _temperatureSetting.recirculation = defaultOption;
    [self addItem:name options:options defaultOption:[defaultOption stringValue] selector:selector cellIdentifier:cellIdentifier];
    
}


- (void)addItem:(NSString *)name options:(NSArray *)options defaultOption:(NSString *)defaultOption selector:(NSString *)selector cellIdentifier:(NSString *)cellIdentifier{
    
    NSMutableDictionary *itemInfo = [@{ kSettingNameKey : name,
                                        kSettingDefualtOptionKey : defaultOption,
                                        kSettingOptionsKey: options,
                                        kSettingSelectorKey : selector,
                                        kSettingCellIdentifierKey : cellIdentifier} mutableCopy];
    
    [_items addObject:itemInfo];
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary *itemInfo = _items[indexPath.row];
    NSString *identifier = [itemInfo valueForKey:kSettingCellIdentifierKey];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = [itemInfo objectForKey:kSettingNameKey];
   
    if ([identifier isEqualToString:kIdentifierCell]) {
        cell.detailTextLabel.text = [itemInfo objectForKey:kSettingDefualtOptionKey];
    }//if
    else if ([identifier isEqualToString:kIdentifierSwitchCell]) {
        
        SwitchTableViewCell *switchCell = (SwitchTableViewCell *)cell;
        BOOL on =  [[itemInfo valueForKey:kSettingDefualtOptionKey] boolValue];
        [switchCell.switchControl setOn:on];
        
        switchCell.switchTableViewSwitchValueChangelHandler = ^(SwitchTableViewCell *switchTableViewCell, UISwitch *switchControl) {
            
            NSIndexPath *indexPath = [self.tableView indexPathForCell:switchTableViewCell];
            NSMutableDictionary *itemInfo = _items[indexPath.row];
            NSNumber *switchValue = [NSNumber numberWithBool:switchControl.on];
            [itemInfo setValue:switchValue forKey:kSettingDefualtOptionKey];
            if ([[itemInfo valueForKey:kSettingNameKey] isEqualToString:NSLS_RECIRCULATION]) {
                [_temperatureSetting setRecirculation:switchValue];
            }
        };
        
    }//else if
   
    

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *itemInfo = _items[indexPath.row];
    SEL selector = NSSelectorFromString([itemInfo valueForKey:kSettingSelectorKey]);
    if (selector && [self respondsToSelector:selector]) {
        
        NSMethodSignature *signature = [self methodSignatureForSelector:selector];;
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:selector];
        [invocation invoke];
    }//if
}


#pragma mark - Navigation

 - (void)openSelectionTableViewController {
 
     SelectionTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionTableViewController"];
     
     NSDictionary *itemInfo = _items[self.tableView.indexPathForSelectedRow.row];
     controller.defaultOption = [itemInfo valueForKey:kSettingDefualtOptionKey];
     controller.options = [itemInfo valueForKey:kSettingOptionsKey];
     controller.title = [itemInfo valueForKey:kSettingNameKey];
     
     controller.selectionTableViewControllerDidSelectObjectHandler = ^(NSString * object) {
     
         NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
         NSMutableDictionary *itemInfo = _items[indexPath.row];
         [itemInfo setObject:object forKey:kSettingDefualtOptionKey];
         
         if ([[itemInfo valueForKey:kSettingNameKey] isEqualToString:NSLS_TEMPERATURE]) {
             [_temperatureSetting setTemperature:object];
         }
         else if ([[itemInfo valueForKey:kSettingNameKey] isEqualToString:NSLS_COOLING]) {
             [_temperatureSetting setCooling:object];
         }
         [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
     
     };
     
     [self.navigationController pushViewController:controller animated:YES];
 }

@end
