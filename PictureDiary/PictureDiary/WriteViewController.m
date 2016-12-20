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
UICollectionViewDelegateFlowLayout, UITextViewDelegate>

//PHPhoto
@property (nonatomic, strong)PHPhotoLibrary *specialLibrays;
@property (nonatomic, strong)PHAssetChangeRequest *chageRequest;
@property (nonatomic,strong)PHObjectPlaceholder *assetPlaceholder;

@property (weak, nonatomic) IBOutlet UITextField *subjectTextfiled;

@property (weak, nonatomic) IBOutlet UITextView *bodyTextView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGesture;


//deleteImage
@property UIButton *deleteButton;


//collectionView Image
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewImage;

//photoArray
@property (strong, nonatomic) NSMutableArray *photoArray;
@property (weak, nonatomic) UIImage *photoImage;

//photoInteger
@property NSInteger photoStart;
@property NSInteger photoEnd;

@end

@implementation WriteViewController

//Using generated synthesizers

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tapGesture.cancelsTouchesInView = NO;
    
    self.collectionViewImage.dataSource = self;
    self.collectionViewImage.delegate = self;
    self.bodyTextView.delegate = self;
    
    self.seletedImages = [[NSMutableArray alloc] init];
    self.photoArray = [[NSMutableArray alloc] init];
    
    NSLog(@"%lf",self.view.frame.size.height);
    
    self.bodyTextView.layer.borderWidth = 1.0;
    self.bodyTextView.layer.borderColor = [UIColor blackColor].CGColor;
    
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
        
        NSMutableDictionary *imageDataDictionary = [[NSMutableDictionary alloc] init];
        [imageDataDictionary setObject:self.photoImage forKey:@"image"];
        [imageDataDictionary setObject:[NSNumber numberWithUnsignedInteger:i] forKey:@"imageNumber"];
        
        [self.photoArray addObject:imageDataDictionary];
        
    }
    
}

//CheckButton
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
        
        WriteViewController * __weak wself = self;
        
        [RequestObject requestWriteData:self.subjectTextfiled.text cotent:self.bodyTextView.text imageArray:self.seletedImages updateFinishDataBlock:^{
            [wself writeViewReset];
            [RequestObject requestMainData];
        }];
        
    }
}

- (void)writeViewReset {
    
    self.subjectTextfiled.text = @"";
    self.bodyTextView.text = @"";
    
    [self.seletedImages removeAllObjects];
    [self.collectionViewImage reloadData];
    
}

//keyboard down
- (IBAction)touchupInsideBackground:(UITapGestureRecognizer *)sender {
    
    [self.subjectTextfiled resignFirstResponder];
}

//make cell number
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.photoArray.count;
}

//make cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomCollectionCell *cell = (CustomCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
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

//textView range.lenth
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ( range.length > 10 ) {
        
        NSLog(@"WriteViewController range.length = %ld ",range.length);
    }
    
    return YES;
}

- (IBAction)tapGestureMethod:(UITapGestureRecognizer *)sender {
    
    [self.subjectTextfiled resignFirstResponder];
    [self.bodyTextView resignFirstResponder];
    
}



@end
