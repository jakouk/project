//
//  WriteViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "WriteViewController.h"
#import "CustomCollectionCell.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetChangeRequest.h>
#import <Photos/PHCollection.h>
#import <Photos/PHImageManager.h>

@interface WriteViewController () <UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImage;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextfiled;
@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

//PHPhoto
@property (weak, nonatomic) PHPhotoLibrary *specialLibrays;
@property (weak, nonatomic) PHAssetChangeRequest *chageRequest;
@property (weak, nonatomic) PHObjectPlaceholder *assetPlaceholder;


@property NSMutableArray *seletedImages;
@property UIButton *deleteButton;
@property (nonatomic) NSMutableArray *photoArray;
@property (weak, nonatomic) UIImage *photoImage;

@property NSInteger photoCount;
@property NSInteger photoEnd;

@end

@implementation WriteViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    
    self.photoCount = 0;
    self.tapGesture.cancelsTouchesInView = NO;
    
    self.collectionViewImage.dataSource = self;
    self.collectionViewImage.delegate = self;
    
    self.subjectTextfiled.delegate = self;
    self.bodyTextView.delegate = self;
    
    self.seletedImages = [[NSMutableArray alloc] init];
    self.photoArray = [[NSMutableArray alloc] init];
    
    NSLog(@"%lf",self.view.frame.size.height);
    
    [self.subjectTextfiled setFont:[UIFont systemFontOfSize:20]];
    
    [self.bodyTextView setFont:[UIFont systemFontOfSize:20]];
    self.bodyTextView.layer.borderWidth = 1.0;
    self.bodyTextView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self loadImageInDevicePhotoLibray:self.photoCount];
    
    // each Product photoCollection Height
    if (self.view.frame.size.height >= 736) {
        
        self.photoCollectionHeight.constant = 250;
        
    } else if (self.view.frame.size.height >=667) {
        
        self.photoCollectionHeight.constant = 200;
        
    }
    
}

# pragma mark - PHphoto method
- (void)loadImageInDevicePhotoLibray:(NSUInteger)range{
    
    self.photoCount +=40;
    PHFetchResult *albumList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                        subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                        options:nil];
    
    PHAssetCollection *smartFolderAssetCollection = (PHAssetCollection *)[albumList firstObject];
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:smartFolderAssetCollection  options:nil];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.networkAccessAllowed = YES;
    options.synchronous = YES;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    PHImageManager *photoManager = [PHImageManager defaultManager];
    
    for (NSInteger i = range;i<assets.count;i++) {
        [photoManager requestImageForAsset:assets[i] targetSize:CGSizeMake(100,100) contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            NSMutableDictionary *imageDataDictionary = [[NSMutableDictionary alloc] init];
            [imageDataDictionary setObject:result forKey:@"image"];
            [imageDataDictionary setObject:[NSNumber numberWithUnsignedInteger:i] forKey:@"imageNumber"];
            [self.photoArray addObject:imageDataDictionary];
            
        }];
        
        if(self.photoArray.count == self.photoCount){
            
            NSLog(@"self.photoArray.count : %ld",self.photoArray.count);
            
            return ;
        }
    }
    
}

# pragma mark - checkButton
// CheckButton
- (IBAction)touchupInsideCheckButton:(UIButton *)sender {
    
    if ( self.seletedImages.count == 0 ) {
        
        UIAlertController *imageCountAlert = [UIAlertController alertControllerWithTitle:@"사진선택"
                                                                                 message:@"사진을 선택하지 않으셨습니다. 사진은 선택해 주세요"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *check = [UIAlertAction actionWithTitle:@"확인"
                                                        style:UIAlertActionStyleDefault
                                                      handler:nil];
        
        [imageCountAlert addAction:check];
        [self presentViewController:imageCountAlert animated:YES completion:nil];
        
    } else {
        NSLog(@"WriteViewController self.seletedImages.count = %ld ",self.seletedImages.count);
        
        PHFetchResult *albumList = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                            subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                            options:nil];
        
        PHAssetCollection *smartFolderAssetCollection = (PHAssetCollection *)[albumList firstObject];
        PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:smartFolderAssetCollection  options:nil];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.networkAccessAllowed = YES;
        options.synchronous = YES;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        PHImageManager *photoManager = [PHImageManager defaultManager];
        
        NSMutableArray *sendArray = [[NSMutableArray alloc]init];
        [sendArray removeAllObjects];
        
        for (NSInteger i = 0;i<self.seletedImages.count;i++) {
            
            NSDictionary *imageDic = [self.seletedImages objectAtIndex:i];
            NSNumber *imageNubmer = [imageDic objectForKey:@"imageNumber"];
            
            [photoManager requestImageForAsset:assets[imageNubmer.integerValue] targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                NSMutableDictionary *imageDataDictionary = [[NSMutableDictionary alloc] init];
                [imageDataDictionary setObject:result forKey:@"image"];
                [imageDataDictionary setObject:[NSNumber numberWithUnsignedInteger:i] forKey:@"imageNumber"];
                [sendArray addObject:imageDataDictionary];
                
            }];
        }
        
        
        self.indicator.hidden = NO;
        [self.indicator startAnimating];
        
        UIView __block *delayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        delayView.backgroundColor = [UIColor grayColor];
        delayView.alpha = 0.5;
        [self.view addSubview:delayView];
        
        WriteViewController * __weak wself = self;
        
        [PDPageManager requestWriteData:self.subjectTextfiled.text cotent:self.bodyTextView.text imageArray:sendArray updateFinishDataBlock:^{
            
            [wself writeViewReset];
            [delayView removeFromSuperview];
            
        }];
        
    }
}


// After write
- (void)writeViewReset {
    
    self.subjectTextfiled.text = @"";
    self.bodyTextView.text = @"";
    
    [self.seletedImages removeAllObjects];
    [self.collectionViewImage reloadData];
    
    self.indicator.hidden = YES;
    [self.indicator stopAnimating];
    
    [self.tabBarController setSelectedIndex:0];
    
}


#pragma mark - cell Method

// make cell number
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArray.count;
}


// make cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __block CustomCollectionCell *cell = (CustomCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cell = [cell initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
        
        NSDictionary *imageData = [self.photoArray objectAtIndex:indexPath.row];
        UIImage *image = [imageData objectForKey:@"image"];
        cell.imageView.image = image;
        
        for ( NSInteger i =0; i < self.seletedImages.count; i++ ) {
            
            NSDictionary *imageData = [self.seletedImages objectAtIndex:i];
            NSNumber *imageNumber = [imageData objectForKey:@"imageNumber"];
            
            NSLog(@"\n imageNubmer.interValue = %ld",imageNumber.integerValue);
            NSLog(@"\n indexPath.row = %ld",indexPath.row);
            
            if ( imageNumber.integerValue == indexPath.row ) {
                [cell.imageView setAlpha:0.5];
                break;
            } else {
                [cell.imageView setAlpha:1.0];
            }
        }

        
    });
    
    return cell;
    
}


// cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 55) /4, (self.view.frame.size.width - 55 )/4);
}


// in Spacing
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

// cell Spacing
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


//cell selected
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCollectionCell *cell = (CustomCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ( self.seletedImages.count < 5) {
        
        if ( cell.imageView.alpha == 0.5 ) {
            
            for ( NSInteger i =0; i < self.seletedImages.count; i++ ) {
                
                NSDictionary *imageData = [self.seletedImages objectAtIndex:i];
                NSNumber *imageNumber = [imageData objectForKey:@"imageNumber"];
                
                if ( imageNumber.integerValue == indexPath.row ) {
                    [cell.imageView setAlpha:1];
                    [self.seletedImages removeObjectAtIndex:i];
                }
                
            }
            
        }else if ( cell.imageView.alpha == 1.0  ) {
            
            NSLog(@"\n didSelectedItemAtIndexPath = %ld\n",indexPath.row);
            
            [cell.imageView setAlpha:0.5];
            [self.seletedImages addObject: [self.photoArray objectAtIndex:indexPath.row]];
        }
    } else {
        
        if ( cell.imageView.alpha == 1.0 ) {
            
            UIAlertController *imageCountAlert = [UIAlertController alertControllerWithTitle:@"사진개수"
                                                                                     message:@"사진개수를 초과하였습니다. ( 최대 5개 )"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *check = [UIAlertAction actionWithTitle:@"확인"
                                                            style:UIAlertActionStyleDefault
                                                          handler:nil];
            
            [imageCountAlert addAction:check];
            [self presentViewController:imageCountAlert animated:YES completion:nil];
            
        } else {
            
            for ( NSInteger i =0; i < self.seletedImages.count; i++ ) {
                
                NSDictionary *imageData = [self.seletedImages objectAtIndex:i];
                NSNumber *imageNumber = [imageData objectForKey:@"imageNumber"];
                
                if ( imageNumber.integerValue == indexPath.row ) {
                    
                    [cell.imageView setAlpha:1];
                    [self.seletedImages removeObjectAtIndex:i];
                }
                
            }
            
        }
    }
}


#pragma mark - scrollDelegate
// scrolldragg 시작시점
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    CGFloat contentHeight = scrollView.contentSize.height;
    if (offsetY < contentHeight-30)
    {
        [self loadImageInDevicePhotoLibray:self.photoCount];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0 animations:^{
                [self.collectionViewImage performBatchUpdates:^{
                    [self.collectionViewImage reloadSections:[NSIndexSet indexSetWithIndex:0]];
                } completion:nil];
            }];
        });
    }
}


#pragma mark - etc Method ( keyboard, gesture )

// returnKey push
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.bodyTextView becomeFirstResponder];
    return YES;
}


- (IBAction)tapGestureMethod:(UITapGestureRecognizer *)sender {
    
    [self.subjectTextfiled resignFirstResponder];
    [self.bodyTextView resignFirstResponder];
}



@end
