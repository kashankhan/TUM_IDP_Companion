//
//  SettingsTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 09/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "SWRevealViewController.h"
#import "SelectionTableViewController.h"
#import "TemperatureSettingsTableViewController.h"
#import "VMServiceRequestBAL.h"
#import "VMServiceDAL.h"


@interface SettingsTableViewController () {

    NSMutableArray *_items;
    VMServiceRequestBAL *_serviceRequestBAL;
    VMServiceDAL *_serviceDAL;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;

@end

static NSString * kSettingNameKey = @"SettingName";
static NSString * kSettingDefualtOptionKey = @"SettingDefaultOption";
static NSString * kSettingOptionsKey = @"SettingOptions";
static NSString * kSettingSelectorKey = @"SettingSelector";


@implementation SettingsTableViewController

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
    
    _items = [@[]mutableCopy];
      //  [self addTemperatureItem];
    [self configureNavigationBarItems];
    [self loadSettings];
    [self syncServices];

}

- (void)syncServices {

    if (!_serviceRequestBAL) {
        _serviceRequestBAL = [VMServiceRequestBAL new];
    }
    
    [self showProgressHud:ProgressHudNormal title:NSLS_PLEASE_WAIT interaction:YES];
    [_serviceRequestBAL sendRequestForServices:^(id response, NSError *error) {
        
        [self loadSettings];
        [self dismissProgressHud];
    }];


}
- (void)loadSettings {

    if (!_serviceDAL) {
         _serviceDAL = [VMServiceDAL new];
    }
    
    [_items removeAllObjects];
    
    [_items addObjectsFromArray:[_serviceDAL services]];
    [self.tableView reloadData];
}

- (void)addTemperatureItem {
    
    NSString *empty = @"";
    NSArray *options = @[];
    NSString *name = NSLS_TEMPERATURE;
    NSString *selector = @"openTemperatureSettings";
    
    [self addItem:name options:options defaultOption:empty selector:selector];
}

- (void)addItem:(NSString *)name options:(NSArray *)options defaultOption:(NSString *)defaultOption selector:(NSString *)selector {

    NSMutableDictionary *itemInfo = [@{ kSettingNameKey : name,
                                 kSettingDefualtOptionKey : defaultOption,
                                 kSettingOptionsKey: options,
                                        kSettingSelectorKey : selector} mutableCopy];
    
    [_items addObject:itemInfo];

}

- (void)configureNavigationBarItems {
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
    static NSString *identifierCell = @"IdentifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
   // NSMutableDictionary *itemInfo = _items[indexPath.row];
    Service *service = _items[indexPath.row];
    cell.textLabel.text = service.name;// [itemInfo objectForKey:kSettingNameKey];
   // cell.detailTextLabel.text = [itemInfo objectForKey:kSettingDefualtOptionKey];
    return cell;
    
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

//   NSMutableDictionary *itemInfo = _items[indexPath.row];
//    SEL selector = NSSelectorFromString([itemInfo valueForKey:kSettingSelectorKey]);
//    if (selector && [self respondsToSelector:selector]) {
//        
//        NSMethodSignature *signature = [self methodSignatureForSelector:selector];;
//        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//        [invocation setTarget:self];
//        [invocation setSelector:selector];
//        [invocation invoke];
//    }//if


}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}

- (void)openSelectionTableViewController {
    
    SelectionTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectionTableViewController"];
    
    NSDictionary *itemInfo = _items[self.tableView.indexPathForSelectedRow.row];
    controller.defaultOption = [itemInfo valueForKey:kSettingDefualtOptionKey];
    controller.options = [itemInfo valueForKey:kSettingOptionsKey];
    controller.title = [itemInfo valueForKey:kSettingNameKey];
    
    controller.selectionTableViewControllerDidSelectObjectHandler = ^(id object) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        NSMutableDictionary *itemInfo = _items[indexPath.row];
        [itemInfo setObject:object forKey:kSettingDefualtOptionKey];
        
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    };
}

- (void)openTemperatureSettings {
    
    TemperatureSettingsTableViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TemperatureSettingsTableViewController"];
    NSDictionary *itemInfo = _items[self.tableView.indexPathForSelectedRow.row];
    controller.title = [itemInfo valueForKey:kSettingNameKey];
    
    [self.navigationController pushViewController:controller animated:YES];
}
@end
