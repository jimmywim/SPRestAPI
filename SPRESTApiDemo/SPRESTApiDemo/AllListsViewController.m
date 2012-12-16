//
//  MasterViewController.m
//  SPRESTApiDemo
//
//  Created by James Love on 12/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "AllListsViewController.h"
#import "DetailViewController.h"
#import "SPAuthCookies.h"
#import "SPRESTQuery.h"
#import "SMXMLDocument.h"


@interface AllListsViewController () {
    NSMutableArray *_objects;
}
@end

@implementation AllListsViewController

@synthesize spinner;
@synthesize siteUrl;
@synthesize webTitle;


//NSString *webtitle;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    self.webTitle = @"";
    // check to see if we have cookies
    if ([[[SPAuthCookies sharedSPAuthCookie] fedAuth] length] == 0)
    {
        NSLog(@"Not logged in!");
        self.items = [NSArray arrayWithObjects:@"Row 1", @"Row 2", @"Row 3", nil];
        return;
    }
    
    
    NSMutableString *titleQueryUrl = [[NSMutableString alloc] initWithString:siteUrl];
    [titleQueryUrl appendString:@"/_api/web/Title"];
                                       
    SPRESTQuery *titleQuery = [[SPRESTQuery alloc] initWithUrlRequestId:titleQueryUrl id:@"SiteTitle"];
    [titleQuery setDelegate:(id)self];
    [titleQuery executeQuery];
    
    NSMutableString *listQueryUrl = [[NSMutableString alloc] initWithString:siteUrl];
    [listQueryUrl appendString:@"/_api/lists"];
    
    SPRESTQuery *listsQuery = [[SPRESTQuery alloc] initWithUrlRequestId:listQueryUrl id:@"Lists"];
    [listsQuery setDelegate:(id)self];
    [listsQuery executeQuery];
}

-(void)SPREST:(id)SPREST didCompleteQueryWithRequestId:(SMXMLDocument *)result requestId:(NSString *)requestId{
    
    if (requestId == @"SiteTitle")
    {
        SMXMLElement *bodyElement = result.root;
        NSString *titleText = [bodyElement value];
        self.navigationItem.title = titleText;
        self.webTitle = titleText;
    }
    else if (requestId == @"Lists")
    {
        NSMutableArray *listsArray = [NSMutableArray alloc];
        listsArray = [listsArray initWithCapacity:[[result.root childrenNamed:@"entry"] count]];
        
        for(SMXMLElement *list in [result.root childrenNamed:@"entry"])
        {
            NSString *listName = [[[list childNamed:@"content"] childNamed:@"properties"] valueWithPath:@"Title"];
            
            //NSLog(@"List: %@", listName);
            [listsArray addObject:listName];
        }
        
        //NSLog(@"Setting lists array");
        self.items = listsArray;
    }
    [self.tableView reloadData];
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
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.webTitle;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
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
    self.detailViewController.detailItem = [self.items objectAtIndex:indexPath.row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowListItems"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        //NSString *object = _objects[indexPath.row];
        
        NSString *selectedListTitle = [self.items objectAtIndex:indexPath.row];
        [[segue destinationViewController] setSiteUrl:siteUrl];
        [[segue destinationViewController] setListTitle:selectedListTitle];
    }
}

@end
