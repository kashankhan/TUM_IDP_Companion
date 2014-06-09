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

@interface SettingsTableViewController () {

    NSMutableArray *_items;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;

@end

static NSString * kSettingNameKey = @"SettingName";
static NSString * kSettingDefualtOptionKey = @"SettingDefaultOption";
static NSString * kSettingOptionsKey = @"SettingOptions";


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
    [self addMusicItem];
    
    [self configureNavigationBarItems];

}

- (void)addMusicItem {
    
    NSString *news = NSLS_NEWS;
    NSString *artists = NSLS_ARTISTS;
    NSString *songs = NSLS_SONGS;
    NSArray *options = @[news , artists, songs];
    NSString *name = NSLS_MUSIC;
    
    [self addItem:name options:options defaultOption:songs];
}
- (void)addItem:(NSString *)name options:(NSArray *)options defaultOption:(NSString *)defaultOption {

    NSMutableDictionary *itemInfo = [@{ kSettingNameKey : name,
                                 kSettingDefualtOptionKey : defaultOption,
                                 kSettingOptionsKey: options } mutableCopy];
    
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
    
    NSMutableDictionary *itemInfo = _items[indexPath.row];
    cell.textLabel.text = [itemInfo objectForKey:kSettingNameKey];
    cell.detailTextLabel.text = [itemInfo objectForKey:kSettingDefualtOptionKey];
    return cell;
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"SegueIdentiferSelectionTableViewController"]) {
        
        SelectionTableViewController *controller = [segue destinationViewController];
        
        NSDictionary *itemInfo = _items[self.tableView.indexPathForSelectedRow.row];
        controller.defaultOption = [itemInfo valueForKey:kSettingDefualtOptionKey];
        controller.options = [itemInfo valueForKey:kSettingOptionsKey];
        controller.title = [itemInfo valueForKey:kSettingNameKey];
       
        controller.selectionTableViewControllerDidSelectObjectHandler = ^(NSString * object) {
             NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
            NSMutableDictionary *itemInfo = _items[indexPath.row];
            [itemInfo setObject:object forKey:kSettingDefualtOptionKey];
            
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        };
    }
}

@end
