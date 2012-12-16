//
//  ImageChooserViewController.m
//  SPRESTApiDemo
//
//  Created by James Love on 15/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "ImageChooserViewController.h"

@interface ImageChooserViewController ()
{
    UIImagePickerController *picker;
    IBOutlet UIImageView *selectedImage;
}
@end

@implementation ImageChooserViewController

@synthesize selectedImage;


- (IBAction) buttonClicked
{
    picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:TRUE completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker
{
    [Picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    selectedImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [Picker dismissViewControllerAnimated:YES completion:nil];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
