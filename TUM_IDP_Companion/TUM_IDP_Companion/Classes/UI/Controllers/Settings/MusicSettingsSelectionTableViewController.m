//
//  MusicSettingsSelectionTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 14/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "MusicSettingsSelectionTableViewController.h"
#import "SelectionTableViewController.h"
#import "SettingsDAL.h"
#import "SWRevealViewController.h"

@interface MusicSettingsSelectionTableViewController (){
    
    SettingsDAL *_settingsDAL;
    NSMutableArray *_items;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;

@end

typedef NS_ENUM(NSInteger, SelectedTab) {
    SelectedTabDiscover         = 0,
    SelectedTabIndividual       = 1,
    SelectedTabLocalMusic       = 2
};

static NSString * kSettingDefualtOptionKey = @"SettingDefaultOption";
static NSString * kSettingOptionsKey = @"SettingOptions";
static NSUInteger kSelectedSegmentIndex;
static CGFloat    kSectionHeaderHeight = 40.0f;
static NSString * kSegueIdentiferSelectionTableViewController = @"SegueIdentiferSelectionTableViewController";

@implementation MusicSettingsSelectionTableViewController

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
- (void)configureNavigationBarItems {
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    self.menuBarButton.target = self.revealViewController;
    self.menuBarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (NSArray *)musicChannels {
    
    return  [_settingsDAL musicChannels];
}

- (void)configureViewSettings {
    
    [self configureNavigationBarItems];
    [self initializeDAL];
    [self addTableHeader];
}

- (void)initializeDAL {

    if (!_settingsDAL) {
        _items = [@[] mutableCopy];
        _settingsDAL = [SettingsDAL new];
    }
    
    [self configureDAL];
}

- (void)configureDAL {
    
    [_items removeAllObjects];
    
    NSArray *musicFeeds = [_settingsDAL musicFeeds];
    [_items addObject:@{NSLS_NEWS:musicFeeds}];
    
    if (kSelectedSegmentIndex != SelectedTabLocalMusic) {
        
        MusicSong *musicSong = [_settingsDAL musicSong];
        NSArray *musicSongs = @[musicSong];
        [_items addObject:@{NSLS_SONGS:musicSongs}];
        
        MusicArtist *musicArtist = [_settingsDAL musicArtist];
        NSArray *musicArtists = @[musicArtist];
        [_items addObject:@{NSLS_ARTISTS:musicArtists}];
        
    }
}

- (void)segmentControlSegmentDidChange:(UISegmentedControl *)segmentControl {
    
    kSelectedSegmentIndex = segmentControl.selectedSegmentIndex;
    NSArray *musicChannels = [self musicChannels];
    for (MusicChannel *musicChannel in musicChannels) {
        [musicChannel setSelected:@(NO)];
    }
    
    MusicChannel *musicChannel = [musicChannels objectAtIndex:kSelectedSegmentIndex];
    [musicChannel setSelected:@(YES)];
    
    [self configureDAL];
    
    [self.tableView reloadData];
}

- (void)addTableHeader {

    NSArray *musicChannels = [self musicChannels];
    NSMutableArray *channels = [@[] mutableCopy];
    
    for (MusicChannel *musicChannel in musicChannels) {
        [channels addObject:musicChannel.name];
    }
    
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:channels];
    
    [segmentControl setFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), kSectionHeaderHeight)];
    [segmentControl addTarget:self action:@selector(segmentControlSegmentDidChange:) forControlEvents:UIControlEventValueChanged];
    
    segmentControl.selectedSegmentIndex = kSelectedSegmentIndex;
    
    [self.tableView setTableHeaderView:segmentControl];
}

- (NSArray *)objectsInSection:(NSInteger)section {
    
   NSDictionary *itemInfo = [_items objectAtIndex:section];
   NSString *key = [[itemInfo allKeys] lastObject];
    NSArray *items = [itemInfo objectForKey:key];
    
    return items;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {

    NSArray *items = [self objectsInSection:indexPath.section];
    id object = nil;
    if (items && [items count]) {
        object = [items objectAtIndex:indexPath.row];
    }
    
    return object;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *items = [self objectsInSection:section];
    return (items && [items count]) ? [items count] : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"IdentifierCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSDictionary *itemInfo = [_items objectAtIndex:section];
    NSString *key = [[itemInfo allKeys] lastObject];
    return key;
}
#pragma mark -UItableView Delegate methods.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
//    NSDictionary *itemInfo = self.options[indexPath.row];
//    NSString *key = [[itemInfo allKeys] lastObject];
//    if ([key isEqualToString:NSLS_NEWS]) {
//        [self performSegueWithIdentifier:kSegueIdentiferSelectionTableViewController sender:self];
//    }//if
//    else {
//    
//         [self selectIndex:indexPath];
//    }//else

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kSectionHeaderHeight;
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
//    NSDictionary *itemInfo = self.options[[self.tableView indexPathForSelectedRow].row];
//    NSString *key = [[itemInfo allKeys] lastObject];
//    NSArray *objects = [itemInfo valueForKey:key];
//    if ([[segue identifier] isEqualToString:kSegueIdentiferSelectionTableViewController]) {
//        SelectionTableViewController *controller = (SelectionTableViewController *)[segue destinationViewController];
//        [controller setOptions:objects];
//        [controller setDefaultOption:self.defaultOption];
//        [controller setTitle:key];
//        
//        controller.selectionTableViewControllerDidSelectObjectHandler = ^(NSString * object) {
//             UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
//            cell.detailTextLabel.text = object;
//        };
//
//    }
}


@end
