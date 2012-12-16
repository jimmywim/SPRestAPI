//
//  ListItemViewController.m
//  SPRESTApiDemo
//
//  Created by James Love on 15/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "ListItemViewController.h"
#import "ImageChooserViewController.h"
#import "SPRESTQuery.h"

@interface ListItemViewController ()
{
    NSMutableArray *_objects;
}
@end

@implementation ListItemViewController

@synthesize listTitle;
@synthesize listItems;
@synthesize siteUrl;
@synthesize baseTemplateType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshItemsCollection];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self refreshItemsCollection];
}

-(void)refreshItemsCollection
{
    NSMutableString *titleQueryUrl = [[NSMutableString alloc] initWithString:siteUrl];
    [titleQueryUrl appendFormat:@"/_api/web/lists/GetByTitle('%@')/items", listTitle];
    
    SPRESTQuery *titleQuery = [[SPRESTQuery alloc] initWithUrlRequestId:titleQueryUrl id:@"ListItems"];
    [titleQuery setDelegate:(id)self];
    [titleQuery executeQuery];
}

-(void)SPREST:(id)SPREST didCompleteQueryWithRequestId:(SMXMLDocument *)result requestId:(NSString *)requestId{
    
    if (requestId == @"ListItems")
    {
        NSMutableArray *listsArray = [NSMutableArray alloc];
        listsArray = [listsArray initWithCapacity:[[result.root childrenNamed:@"entry"] count]];
        
        for(SMXMLElement *list in [result.root childrenNamed:@"entry"])
        {        
            NSString *title = [[[list childNamed:@"content"] childNamed:@"properties"] valueWithPath:@"Title"];
            
            if ([title length] == 0)
            {
                NSString *name = [[[list childNamed:@"content"] childNamed:@"properties"] valueWithPath:@"Name"];
                if ([name length] > 0)
                    [listsArray addObject:name];                
            }
            else
            {
                [listsArray addObject:title];
            }
        }
        
        //NSLog(@"Setting lists array");
        self.listItems = listsArray;
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listItems count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.listTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    //
    //    NSDate *object = _objects[indexPath.row];
    //    cell.textLabel.text = [object description];
    //    return cell;
    
    static NSString *CellIdentifier = @"ItemCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.listItems objectAtIndex:indexPath.row];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //        NSDate *object = _objects[indexPath.row];
    //        self.detailViewController.detailItem = object;
    //    }
    
    //self.detailViewController.detailItem = [self.items objectAtIndex:indexPath.row];
    //[self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    //[self performSegueWithIdentifier:@"showDetail" sender:self.view];
    
    //self.detailViewController.detailItem = [self.items objectAtIndex:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"AskForFileToUpload"])
    {
        NSMutableString *listUrl = [NSMutableString stringWithString:siteUrl];
        [listUrl appendFormat:@"/_api/web/lists/GetByTitle('%@')", listTitle];
        
        ImageChooserViewController *imagePicker = (ImageChooserViewController *)segue.destinationViewController;
        [imagePicker setListUrl:listUrl];
    }
}

@end
