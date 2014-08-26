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
#import "InputTableViewCell.h"

@interface MusicSettingsSelectionTableViewController (){
    
    SettingsDAL *_settingsDAL;
    NSMutableArray *_items;
    
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuBarButton;
@property (strong, nonatomic) UITextField *textField;

@end

typedef NS_ENUM(NSInteger, SelectedTab) {
    SelectedTabDiscover         = 0,
    SelectedTabLocalMusic       = 1
};

typedef NS_ENUM(NSInteger, MusicInfoSelectedTab) {
    MusicInfoSelectedTabSong            = 0,
    MusicInfoSelectedTabArtist          = 1
};

static NSUInteger kSelectedSegmentIndex;
static NSUInteger kMusicInfoSelectedSegmentIndex;
static CGFloat    kSectionHeaderHeight = 40.0f;
static CGFloat    kPadding             = 10.0f;
static NSString  *kMusicInoKey         = @"MusicInfoKey";

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
    [self.textField resignFirstResponder];
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
        NSMutableArray *music = [@[[self songInfo]] mutableCopy];
        if (kMusicInfoSelectedSegmentIndex == MusicInfoSelectedTabArtist) {
            [music addObject:[self artistInfo]];
        }
        [_items addObject:@{kMusicInoKey:music}];
    }
}

- (void)headerSegmentControlSegmentDidChange:(UISegmentedControl *)segmentControl {
    
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

- (void)musicInfoSegmentControlSegmentDidChange:(UISegmentedControl *)segmentControl {
    
    kMusicInfoSelectedSegmentIndex = segmentControl.selectedSegmentIndex;

    [self configureDAL];
    
    [self.tableView reloadData];
}

- (void)addTableHeader {

    NSArray *musicChannels = [self musicChannels];
    NSMutableArray *channels = [@[] mutableCopy];
    
    for (MusicChannel *musicChannel in musicChannels) {
        [channels addObject:musicChannel.name];
    }
    

    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), kSectionHeaderHeight)];
    UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:channels];
    [segmentControl setFrame:CGRectMake(kPadding, kPadding/2, CGRectGetWidth(self.tableView.frame) - kPadding*2, kSectionHeaderHeight - kPadding/2)];
    [segmentControl addTarget:self action:@selector(headerSegmentControlSegmentDidChange:) forControlEvents:UIControlEventValueChanged];
    
    segmentControl.selectedSegmentIndex = kSelectedSegmentIndex;
    [headerView addSubview:segmentControl];
    [self.tableView setTableHeaderView:headerView];
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

- (void)markFeedAsSelected:(NSIndexPath *)indexPath {
    
    NSArray *musicFeeds = [self objectsInSection:indexPath.section];
    NSIndexPath *lastSelectedIndexPath = nil;
    MusicFeed *selectedMusicFeed = [self objectAtIndexPath:indexPath];
    NSUInteger row = 0;
    for (MusicFeed *musicFeed in musicFeeds) {
        if ([musicFeed.selected boolValue]) {
            lastSelectedIndexPath = [NSIndexPath indexPathForRow:row inSection:indexPath.section];
        }
        [musicFeed setSelected:@(NO)];
        if ([selectedMusicFeed.uri isEqualToString:musicFeed.uri]) {
           [musicFeed setSelected:@(YES)];
        }
        
        row++;
    }
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (lastSelectedIndexPath) {
        cell = [self.tableView cellForRowAtIndexPath:lastSelectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

- (NSDictionary *)artistInfo {
    
    MusicArtist *musicArtist = [_settingsDAL musicArtist];
    return  @{NSLS_ARTIST:musicArtist};
}

- (NSDictionary *)songInfo {
    
    MusicSong *musicSong = [_settingsDAL musicSong];
    return  @{NSLS_SONG:musicSong};
    
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

    NSString *identifier = (indexPath.section == 0) ? @"IdentifierCell": @"IdentifierInputCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if ((indexPath.section == 0)) {
        [self configureDefaultTableViewCell:cell indexPath:indexPath];
    }
    else {
        [self configureInputTableViewCell:cell indexPath:indexPath];
    }
    
    return cell;
}

- (void)configureInputTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
  
    InputTableViewCell *inputCell = (InputTableViewCell *)cell;
    id object = [[[self objectAtIndexPath:indexPath] allObjects] lastObject];
    NSString *placeholder = NSLS_PLEASE_INSERT;
    NSString *text = nil;
    NSString *title = nil;
    
    if ([object isKindOfClass:[MusicArtist class]]) {
        title = NSLS_ARTIST;
        text = ((MusicArtist *)object).name;
        placeholder = [NSString stringWithFormat:@"%@ %@", placeholder, title];
    
    }
    else if ([object isKindOfClass:[MusicSong class]]) {
        title = NSLS_SONG;
        text = ((MusicSong *)object).name;
        placeholder = [NSString stringWithFormat:@"%@ %@", placeholder, title];
    }
    
    inputCell.textField.placeholder = placeholder;
    inputCell.textField.text = text;
    inputCell.titleLabel.text = title;
    
    inputCell.inputTableViewCellTextDidChangeHandler = ^(InputTableViewCell *cell, UITextField *textField) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        self.textField = textField;
        id object = [[[self objectAtIndexPath:indexPath] allObjects] lastObject];
        if ([object isKindOfClass:[MusicArtist class]]) {
            ((MusicArtist *)object).name = textField.text;
            
        }
        else if ([object isKindOfClass:[MusicSong class]]) {
            ((MusicSong *)object).name = textField.text;
        }
    };
}

- (void)configureDefaultTableViewCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    
    MusicFeed *musicFeed = [self objectAtIndexPath:indexPath];
    cell.textLabel.text = musicFeed.name;
    cell.detailTextLabel.text = musicFeed.uri;
    cell.accessoryType = ([musicFeed.selected boolValue]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    NSDictionary *itemInfo = [_items objectAtIndex:section];
    NSString *key = [[itemInfo allKeys] lastObject];
    return key;
}

#pragma mark - Table view  Delegate methods.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    if (indexPath.section == 0) {
        [self markFeedAsSelected:indexPath];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return kSectionHeaderHeight + kPadding;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UIView *sectionView = nil;
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), kSectionHeaderHeight)];
        UISegmentedControl *segmentControl = [[UISegmentedControl alloc] initWithItems:@[NSLS_SONG, NSLS_ARTIST]];
        [segmentControl setFrame:CGRectMake(kPadding, kPadding/2, CGRectGetWidth(self.tableView.frame) - kPadding*2, kSectionHeaderHeight - kPadding/2)];
        [segmentControl addTarget:self action:@selector(musicInfoSegmentControlSegmentDidChange:) forControlEvents:UIControlEventValueChanged];
        
        segmentControl.selectedSegmentIndex = kMusicInfoSelectedSegmentIndex;
        [headerView addSubview:segmentControl];
        sectionView = headerView;
    }
    
    return sectionView;
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
