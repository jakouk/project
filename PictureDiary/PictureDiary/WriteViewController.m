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
#import <Photos/PHAssetChangeRequest.h>
#import <Photos/PHCollection.h>
#import <Photos/PHImageManager.h>

@interface WriteViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

//PHPhoto
@property (nonatomic, strong)PHPhotoLibrary *specialLibrays;
@property (nonatomic, strong)PHAssetChangeRequest *chageRequest;
@property (nonatomic,strong)PHObjectPlaceholder *assetPlaceholder;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextfiled;
@property (weak, nonatomic) IBOutlet UITextField *objectTextfiled;
//@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;


//deleteImage
@property UIButton *deleteButton;


//collectionView Image
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImage;

//photoArray
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (weak, nonatomic) UIImage *photoImage;

@end

@implementation WriteViewController

//Using generated synthesizers

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionViewImage.dataSource = self;
    self.collectionViewImage.delegate = self;
    
    self.chosenImages = [[NSMutableArray alloc] init];
    self.photoArray = [[NSMutableArray alloc] init];
    
    NSLog(@"%lf",self.view.frame.size.height);
    
    //PHAsset
    
    // 카메라 롤 앨범을 읽어온다.
    PHFetchResult *smartFolderLists = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                               subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                               options:nil];
    
    PHAssetCollection *smartFolderAssetCollection = (PHAssetCollection *)[smartFolderLists firstObject];
    //
    
    // 카메라 롤에 있는 사진을 가져온다.
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:smartFolderAssetCollection  options:nil];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageManager *photoManager = [PHImageManager defaultManager];
    
    for (NSInteger i = 0; i < assets.count; i++) {
        [photoManager requestImageForAsset:assets[i] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            self.photoImage = result;
            
        }];
        [self.photoArray addObject:self.photoImage];
    }
 
}

- (void)awakeFromNib {
    [super awakeFromNib];
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

//keyboard down
- (IBAction)touchupInsideBackground:(UITapGestureRecognizer *)sender {
    
    [self.objectTextfiled resignFirstResponder];
    [self.subjectTextfiled resignFirstResponder];
}

//make cell number
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArray.count;
}

//make cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    imageView.image = [self.photoArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:imageView];
    return cell;
    
}

//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 55) /4, (self.view.frame.size.width - 55 )/4);
}

//in Spacing
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//cell Spacing
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

@end
