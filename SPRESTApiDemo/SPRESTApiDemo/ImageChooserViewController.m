//
//  ImageChooserViewController.m
//  SPRESTApiDemo
//
//  Created by James Love on 15/12/2012.
//  Copyright (c) 2012 James Love. All rights reserved.
//

#import "ImageChooserViewController.h"
#import "SPRESTQuery.h"

@interface ImageChooserViewController ()
{
    UIImagePickerController *picker;
    IBOutlet UIImageView *selectedImage;
    IBOutlet UIButton *uploadButton;
    IBOutlet UITextField *filenameTextField;
}
@end

@implementation ImageChooserViewController

@synthesize selectedImage;
@synthesize listUrl;
@synthesize uploadButton;
@synthesize filenameTextField;

- (IBAction) cancelClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

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
    self.uploadButton.enabled = true;
    self.filenameTextField.enabled = true;
}

- (IBAction) uploadButtonClicked
{
    NSString *fileName = self.filenameTextField.text;
    
    if ([fileName length] == 0)
        fileName = @"File1.png";
    
    NSMutableString *fullUploadUrl = [NSMutableString stringWithString:listUrl];
    [fullUploadUrl appendFormat:@"/rootfolder/files/add(url='%@.png', overwrite=true)", fileName];
    
    SPRESTQuery *uploadImageQuery = [[SPRESTQuery alloc] initWithUrlRequestId:fullUploadUrl id:@"UploadImage"];
    [uploadImageQuery setDelegate:(id)self];
    [uploadImageQuery setRequestMethod:@"POST"];
    
    NSData *imageData = UIImagePNGRepresentation(selectedImage.image);
    [uploadImageQuery setAttachedFile:imageData];
    [uploadImageQuery executeQuery];
}

-(void)SPREST:(id)SPREST didCompleteQueryWithRequestId:(SMXMLDocument *)result requestId:(NSString *)requestId{
    
    if (requestId == @"UploadImage")
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
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
    [self.navigationController setNavigationBarHidden:FALSE];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
