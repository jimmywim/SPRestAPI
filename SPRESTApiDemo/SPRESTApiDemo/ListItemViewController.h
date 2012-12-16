//
//  ListItemViewController.h
//  SPRESTApiDemo
//
//  Created by James Love on 15/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListItemViewController : UITableViewController

@property (nonatomic, retain) NSString *listTitle;
@property (strong, nonatomic) NSArray *listItems;
@property (strong, nonatomic) NSString *siteUrl;
@property (strong, nonatomic) NSString *baseTemplateType;
@end
