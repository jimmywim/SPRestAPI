//
//  ImageChooserViewController.h
//  SPRESTApiDemo
//
//  Created by James Love on 15/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageChooserViewController : UIViewController

@property (nonatomic, retain) UIImageView * selectedImage;

- (IBAction) buttonClicked;

@end
