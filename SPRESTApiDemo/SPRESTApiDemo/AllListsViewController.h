//
//  MasterViewController.h
//  SPRESTApiDemo
//
//  Created by James Love on 12/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface AllListsViewController : UITableViewController
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSArray *items;

@property (strong, nonatomic) NSString *siteUrl;
@property (strong, nonatomic) NSString *webTitle;
@end
