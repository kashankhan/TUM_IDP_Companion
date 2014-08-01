//
//  SelectionTableViewController.m
//  TUM_IDP_Companion
//
//  Created by Kashan Khan on 09/06/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "SelectionTableViewController.h"

@interface SelectionTableViewController () 
@end

@implementation SelectionTableViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifierCell = @"IdentifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierCell];
    
    cell.accessoryType = (self.defaultOption && [[self.options objectAtIndex:indexPath.row] isEqual:self.defaultOption]) ? UITableViewCellAccessoryCheckmark: UITableViewCellAccessoryNone;
    
    cell.textLabel.text = self.options[indexPath.row];

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
    [self setDefaultOption:self.options[indexPath.row]];
    // set the check mark to the current object.
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    // send the delegate.
    if (self.selectionTableViewControllerDidSelectObjectHandler) {
        self.selectionTableViewControllerDidSelectObjectHandler(self.defaultOption);
    }//if
    
    // deselecting the last row
    [tableView  deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
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
