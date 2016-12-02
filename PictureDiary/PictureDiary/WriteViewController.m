//
//  WriteViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "WriteViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/PHPhotoLibrary.h>

@interface WriteViewController ()

@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;
//@property (nonatomic, strong)PHPhotoLibrary *specialLibrays;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextfiled;
@property (weak, nonatomic) IBOutlet UITextField *objectTextfiled;
//@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;


//deleteImage
@property UIButton *deleteButton;

@end

@implementation WriteViewController

//Using generated synthesizers

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"viewDidLoad");
//    self.backgroundImage.image = [UIImage imageNamed:@"christmas"];
//    [self.view addSubview:self.backgroundImage];
    
    self.chosenImages = [[NSMutableArray alloc] init];
    NSLog(@"%lf",self.view.frame.size.height);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
}

- (IBAction)launchController
{
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
}

- (void)displayPickerForGroup:(ALAssetsGroup *)group
{
    ELCAssetTablePicker *tablePicker = [[ELCAssetTablePicker alloc] initWithStyle:UITableViewStylePlain];
    tablePicker.singleSelection = YES;
    tablePicker.immediateReturn = YES;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:tablePicker];
    elcPicker.maximumImagesCount = 1;
    elcPicker.imagePickerDelegate = self;
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For single image selection, do not display and return order of selected images
    tablePicker.parent = elcPicker;
    
    // Move me
    tablePicker.assetGroup = group;
    [tablePicker.assetGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    }
}

#pragma mark ELCImagePickerControllerDelegate Methods


//// 선택하면 나오는 화면
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    
    NSLog(@"info count : %ld ",info.count);
    if (info.count == 0) {
        self.scrollViewHeight.constant = 0;
    } else {
        self.scrollViewHeight.constant = self.view.frame.size.width/3;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    NSLog(@"self.scrollView.frame.size.height : %lf",self.scrollView.frame.size.height);
    
    CGRect workingFrame = CGRectMake(0, 20, self.view.frame.size.width/3 - 20, self.view.frame.size.width/3 - 20);
    workingFrame.origin.x = 0;
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    for (NSDictionary *dict in info) {
        
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] init];
                [imageview setImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                [_scrollView addSubview:imageview];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width+20;
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
            
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            
//            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
//                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
//                
//                [images addObject:image];
//                
//                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
//                [imageview setContentMode:UIViewContentModeScaleToFill];
//                imageview.frame = workingFrame;
//                
//                [_scrollView addSubview:imageview];
//                
//                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
//            } else {
//                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
//            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    self.chosenImages = images;
    [_scrollView setPagingEnabled:NO];
    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
}

//imagePicker cancel
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//cancel Button
- (IBAction)touchupInsideCancelButton:(UIButton *)sender {
    
    self.scrollViewHeight.constant = 0;
    self.subjectTextfiled.text = @"";
    self.objectTextfiled.text = @"";
}

//CheckButton
- (IBAction)touchupInsideCheckButton:(UIButton *)sender {
    
    
}

//deleteButton
- (void)touchupInsideImageDeleteButton:(UIButton *)sender {
    
}

- (IBAction)touchupInsideBackground:(UITapGestureRecognizer *)sender {
    
    [self.objectTextfiled resignFirstResponder];
    [self.subjectTextfiled resignFirstResponder];
}

@end
