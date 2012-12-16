//
//  FirstPageViewController.h
//  SPRESTApiDemo
//
//  Created by James Love on 12/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstPageViewController : UIViewController
{
    IBOutlet UIButton *loginButton;
    IBOutlet UITextField *siteUrlField;
    IBOutlet UITextField *usernameField;
    IBOutlet UITextField *passwordField;
}
@property (nonatomic, retain) UITextField *siteUrlField;
@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;

-(IBAction)onLoginClick:(id)sender;

@end
