//
//  SaveLocationTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 02/08/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SaveLocationTableViewController.h"
#import "InputTableViewCell.h"

typedef NS_ENUM(NSInteger, SectionType) {
    SectionAddress,
    SectionAddressCatagory,
    SectionAddCustomCatagory
};
@interface SaveLocationTableViewController ()

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


#pragma mark - Private methods
- (void)configureViewSettings {
    
    [self setTitle:NSLS_ADD_BOOKMARK];
    [self loadDataSource];
    
}

- (void)loadDataSource {
    
    if (!_items) {
        _items = [@[] mutableCopy];
    }
    
    
    NSMutableDictionary *addressInfo = [@{NSLS_ADDRESS: @""} mutableCopy];
    NSArray *section = @[addressInfo];
    
    [_items addObject:section];
    
    section = nil;
    section = [@[NSLS_HOME, NSLS_OFFICE] mutableCopy];
    [_items addObject:section];

    
    section = nil;
    section = @[NSLS_ADD_CUSTOM];
    [_items addObject:section];

    
}


- (IBAction)performSaveAction:(id)sender {

   
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
        if (![catagories containsObject:catagory]) {
            [catagories addObject:catagory];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[catagories count] - 1 inSection:SectionAddressCatagory];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self markAddressCatagorySelected:indexPath];
        }
    }];

}

- (void)markAddressCatagorySelected:(NSIndexPath *)indexPath {
   
     NSMutableArray *catagories = [self objectsInSection:SectionAddressCatagory];
    NSUInteger index = [catagories indexOfObject:self.selectedAddressType];
    NSIndexPath *lastSelectedIndexPath = [NSIndexPath indexPathForRow:index inSection:SectionAddressCatagory];
    self.selectedAddressType = [self objectAtIndexPath:indexPath];
    
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
    
    };
    
    return cell;
    
}

- (UITableViewCell *)configureDefaultTableViewCellForTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"IdentifierDefaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSString *object = [self objectAtIndexPath:indexPath];
    cell.textLabel.text = object;
    cell.accessoryType = ([object isEqualToString:self.selectedAddressType]) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    
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
