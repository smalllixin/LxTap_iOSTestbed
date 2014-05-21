//
//  MasterViewController.m
//  DemoCollect
//
//  Created by lixin on 3/18/14.
//  Copyright (c) 2014 lxstudio. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "ScollPageViewController.h"
@interface MasterViewController () {
    NSMutableArray *_objects;
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

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    [self insertNewObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
//    [_objects insertObject:[NSDate date] atIndex:0];
    [_objects addObject:@"autolayout test"];
    [_objects addObject:@"Rounded Corner View"];
    [_objects addObject:@"Slide To Unlock"];
    [_objects addObject:@"Custom Gesture Test"];
    [_objects addObject:@"Tabbar Test"];
    [_objects addObject:@"ScrollPageTest"];
    [_objects addObject:@"UIDynamics Test"];
    [_objects addObject:@"LED Test"];
    [_objects addObject:@"POP Test"];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = object;
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
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"showDetail" sender:self];
            return;
        case 1:
            [self performSegueWithIdentifier:@"showCustomCorner" sender:self];
            return;
        case 2:
            [self performSegueWithIdentifier:@"slidetounlock" sender:self];
            return;
        case 3:
            [self performSegueWithIdentifier:@"testgesture" sender:self];
        case 4:
            [self performSegueWithIdentifier:@"tabtest" sender:self];
            return;
        case 5:
        {
            ScollPageViewController *v = [[ScollPageViewController alloc] initWithNibName:@"ScollPageViewController" bundle:nil];
            [self.navigationController pushViewController:v animated:YES];
            return;
        }
        case 6:
            [self performSegueWithIdentifier:@"dytest" sender:self];
            return;
        case 7:
            [self performSegueWithIdentifier:@"led_test" sender:self];
            return;
        case 8:
            [self performSegueWithIdentifier:@"poptest" sender:self];
            return;
        default:
            break;
    }
    
}

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *segueId = [segue identifier];
    if ([segueId isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    } else if ([segueId isEqualToString:@"showCustomCorner"]) {
        
    }
        
}

@end
