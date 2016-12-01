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

//@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

@property (nonatomic, strong)PHPhotoLibrary *specialLibrays;


//deleteImage
@property UIButton *deleteButton;

@end

@implementation WriteViewController

//Using generated synthesizers

- (void)viewDidLoad {
    self.chosenImages = [[NSMutableArray alloc] init];
    NSLog(@"%lf",self.view.frame.size.height);
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
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // _scrollView subviews의 모든 요소 삭제
    for (UIView *v in [_scrollView subviews]) {
        [v removeFromSuperview];
    }
    
    //_scrollView.frame을 workingFrame에 대입
    CGRect workingFrame = _scrollView.frame;
    
    //첫번째 사진의 x위치는 0
    workingFrame.origin.x = 0;
    
    //info에 이미지 데이터 있음. 그 데이터 images에 넣음.
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    
    //dict는 NSDictionary 이다.
    for (NSDictionary *dict in info) {
        
        //ALAssetTypePhoto의 타입이 UIImagePickerControllerMediaType이면 실행됨.
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            
            //UIImagePickerControllerOriginalImage이면 실행
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                
                //images라는 dictionary에 image를 넣음.
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                //imageview
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                //추가함. ( for 라서 계속 돌면서 추가함 )
                [_scrollView addSubview:imageview];
                
                //x위치 재지정
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                //UIImagePickerControllerOriginalImage아니면 실행
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
            
            //video 타입이면
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                [_scrollView addSubview:imageview];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    //selected = images
    self.chosenImages = images;
    
    //paging = YES, setContentSize = workingFram.origin.x, workingFrame.size.height
    [_scrollView setPagingEnabled:YES];
    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//cell numbers
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (self.chosenImages.count == 0) {
        return 1;
    } else {
        return self.chosenImages.count + 1;
    }
}



@end
