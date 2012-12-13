//
//  DetailViewController.h
//  SPRESTApiDemo
//
//  Created by James Love on 12/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
