//
//  SingleItemViewController.m
//  SPRESTApiDemo
//
//  Created by James Love on 16/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "SingleItemViewController.h"
#import "SPAuthCookies.h"
#import "SPRESTQuery.h"

@interface SingleItemViewController ()
{
    IBOutlet UIButton *cancelButton;
}
@end

@implementation SingleItemViewController

@synthesize listItem;

- (IBAction) cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

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
	// Do any additional setup after loading the view.
    self.navigationItem.title = self.listItem.title;
    
//    NSMutableString *titleQueryUrl = [[NSMutableString alloc] initWithString:[[SPAuthCookies sharedSPAuthCookie] siteUrl]];
//    
//    [titleQueryUrl appendFormat:@"/_api/web/lists/GetByTitle('%@')/items", listTitle];
//    
//    SPRESTQuery *titleQuery = [[SPRESTQuery alloc] initWithUrlRequestId:titleQueryUrl id:@"ListItems"];
//    [titleQuery setDelegate:(id)self];
//    [titleQuery executeQuery];
//    
//    [self startActivityIndicator];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
