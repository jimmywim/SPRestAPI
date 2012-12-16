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
@property (nonatomic, retain) NSString *listUrl;
@property (nonatomic, retain) UIButton *uploadButton;
@property (nonatomic, retain) UITextField *filenameTextField;

- (IBAction) cancelClicked;
- (IBAction) buttonClicked;
- (IBAction) uploadButtonClicked;

@end
