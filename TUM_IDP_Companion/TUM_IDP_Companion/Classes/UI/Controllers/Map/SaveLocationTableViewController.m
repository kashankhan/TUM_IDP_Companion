//
//  SaveLocationTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SaveLocationTableViewController.h"


typedef NS_ENUM(NSInteger, SectionType) {
    SectionAddress,
    SectionAddressCatagory,
    SectionAddCustomCatagory
};

@interface SaveLocationTableViewController () {

    LocationBookmarkDAL *_locationBookDAL;
}

@property (strong, nonatomic) UITextField *textField;
@end

@implementation SaveLocationTableViewController

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

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self dismissProgressHud];
    [_locationBookDAL saveContext];
}

#pragma mark - Private methods
- (void)configureViewSettings {
    
    [self setTitle:NSLS_ADD_BOOKMARK];
    [self loadDataSource];
    
}

- (void)loadDataSource {
    
    NSMutableArray *landmarks = nil;
    if (!_items) {
        _items = [@[] mutableCopy];
        _locationBookDAL = [LocationBookmarkDAL new];
        landmarks = [[_locationBookDAL landmarks] mutableCopy];
        if (![landmarks count]) {
            [_locationBookDAL insertDefaultLandmarks];
             landmarks = [[_locationBookDAL landmarks] mutableCopy];
        }
    }
    
    NSMutableDictionary *addressInfo = [@{NSLS_ADDRESS: @""} mutableCopy];
    NSArray *addressSection = @[addressInfo];
    
    [_items addObject:addressSection];
    [_items addObject:landmarks];


    NSArray *addCustomSection = @[NSLS_ADD_CUSTOM];
    [_items addObject:addCustomSection];


}


- (IBAction)performSaveAction:(id)sender {

    [self.textField resignFirstResponder];
    NSString *address = _textField.text;
    
    if ([address length] && [self.selectedLandmark.name length]) {
        [self showProgressHud:ProgressHudNormal title:nil interaction:NO];
        
        [LocationHelper locationFromAddressString:address handler:^(CLLocationCoordinate2D coordinate) {
            
            if (coordinate.latitude > 0 &&  coordinate.longitude > 0) {
                LocationBookmark *locationBookmark = [_locationBookDAL newLocationBookmark];
                locationBookmark.name = address;
                locationBookmark.landmarkType = self.selectedLandmark.name;
                locationBookmark.latitude = @(coordinate.latitude);
                locationBookmark.longitude = @(coordinate.longitude);
                
            }
            [self dismissProgressHud];
        }];
    }
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {

   NSArray *section = [self objectsInSection:indexPath.section];
    return [section objectAtIndex:indexPath.row];
}

- (id)objectsInSection:(NSInteger)section {
    
    return [_items objectAtIndex:section];
}

- (void)addCustomAddressCatagory:(NSIndexPath *)indexPath {

    NSString *title = [self objectAtIndexPath:indexPath];
    [UIAlertView showWithTitle:title message:nil style:UIAlertViewStylePlainTextInput cancelButtonTitle:NSLS_CANCEL otherButtonTitles:@[NSLS_OK] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        NSString *catagory = [[alertView textFieldAtIndex:0] text];
        NSMutableArray *catagories = [self objectsInSection:SectionAddressCatagory];
        
        if (![self containObject:catagory list:catagories]) {
            
            Landmark *landmark = [_locationBookDAL newLandmark];
            landmark.name = catagory;
            [catagories addObject:landmark];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[catagories count] - 1 inSection:SectionAddressCatagory];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self markAddressCatagorySelected:indexPath];
        }
    }];

}

- (BOOL)containObject:(NSString *)object list:(NSArray *)landmarks {
    
    BOOL found = NO;
    for (Landmark *landmark in landmarks) {
        if ([landmark.name caseInsensitiveCompare:object] == NSOrderedSame) {
            found = YES;
            break;
        }
    }
    return found;
}

- (void)markAddressCatagorySelected:(NSIndexPath *)indexPath {
   
    NSMutableArray *catagories = [self objectsInSection:SectionAddressCatagory];
    NSUInteger index = [catagories indexOfObject:self.selectedLandmark.name];
    NSIndexPath *lastSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:SectionAddressCatagory];
    Landmark *landmark = [self objectAtIndexPath:indexPath];
    self.selectedLandmark = landmark;
    
    NSMutableArray *indexPaths = [@[indexPath] mutableCopy];
    if (![indexPath isEqual:lastSelectedIndexPath]) {
        [indexPaths addObject:lastSelectedIndexPath];
    }
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_items count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the sect
    return [[self objectsInSection:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = (indexPath.section == SectionAddress) ? [self configureInputTableViewCellForTableView:tableView cellForRowAtIndexPath:indexPath] : [self configureDefaultTableViewCellForTableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}


- (InputTableViewCell *)configureInputTableViewCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"IdentifierInputCell";
    
    NSDictionary *contentInfo = [self objectAtIndexPath:indexPath];
    NSString *key = [[contentInfo allKeys] lastObject];
    InputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
   
    cell.textField.placeholder = key;
    cell.textField.text = [contentInfo valueForKey:key];
    
    cell.inputTableViewCellTextDidChangeHandler = ^(InputTableViewCell *cell, UITextField *textField) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        NSMutableDictionary *contentInfo = [self objectAtIndexPath:indexPath];
        NSString *key = [[contentInfo allKeys] lastObject];
        [contentInfo setObject:textField.text forKey:key];
        self.textField = textField;
    
    };
    
    return cell;
    
}

- (UITableViewCell *)configureDefaultTableViewCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"IdentifierDefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    id object = [self objectAtIndexPath:indexPath];
    NSString *landmarkName = ([object isKindOfClass:[Landmark class]]) ? ((Landmark *)object).name : object;
    cell.textLabel.text = landmarkName;
    cell.accessoryType = ([landmarkName isEqualToString:self.selectedLandmark.name]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;
    return (section == SectionAddressCatagory && row > 1) ? YES : NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case SectionAddCustomCatagory:
            [self addCustomAddressCatagory:indexPath];
            break;
            
        case SectionAddressCatagory:
            [self markAddressCatagorySelected:indexPath];
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
