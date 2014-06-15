//
//  MasterViewController.m
//  Mausam
//
//  Created by Niyog Ray on 12/06/14.
//  Copyright (c) 2014 Niyog Ray. All rights reserved.
//

#import "MasterViewController.h"
#import "LocationTableViewCell.h"

#import "DetailViewController.h"

@interface MasterViewController ()
{
    NSMutableArray *_objects;
    
    NSMutableArray *locations;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadLocations];
}

- (void)loadLocations
{
    locations = [[LocationStore new] locations];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *nilView = [[UIView alloc] initWithFrame:CGRectZero];
    
    return nilView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
//    LocationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationTableViewCell"];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSDictionary *location = locations[row];
    NSString *locationName = [location objectForKey:@"name"];
    NSString *locationCountryCode = [[location objectForKey:@"sys"] objectForKey:@"country"];
    
//    cell.locationNameLbl.text = [NSString stringWithFormat:@"%@, %@", locationName, locationCountryCode];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", locationName, locationCountryCode];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [locations removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [tableView endEditing:YES];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
    
    [[LocationStore new] saveLocations:locations];
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [locations moveObjectFromIndex:fromIndexPath.row toIndex:toIndexPath.row];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showAddLocation"])
    {
        [self setEditing:NO animated:YES];
    }
    else
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSMutableDictionary *location = locations[indexPath.row];

        [[segue destinationViewController] setLocation:location];
    }
}

@end
