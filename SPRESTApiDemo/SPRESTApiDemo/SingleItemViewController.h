//
//  SingleItemViewController.h
//  SPRESTApiDemo
//
//  Created by James Love on 16/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPRESTListItem.h"

@interface SingleItemViewController : UIViewController
@property (nonatomic, retain) SPRESTListItem *listItem;


- (IBAction) cancelButtonClicked;

@end
