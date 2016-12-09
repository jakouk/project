//
//  MainViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

//ui
#import "MainViewController.h"
#import "CustomCell.h"
<<<<<<< HEAD
=======
#import "CollectionLayout.h"
#import <UIImageView+WebCache.h>
>>>>>>> ddd464469f3d478dcc76ab845946a08a73844d74

//network
#import "RequestObject.h"
#import "NetworkData.h"

@interface MainViewController ()

<<<<<<< HEAD
//사진제목
@property NSArray *photoName;

//사진내용
@property NSArray *photoDetail;

//사진
@property NSArray *photo;
=======
//레이아웃
@property CollectionLayout *slidingLayout;
>>>>>>> ddd464469f3d478dcc76ab845946a08a73844d74

//셀의 크기
@property CGFloat minRatio;
@property CGFloat maxRatio;

@property NSArray *userWord;

@end

@implementation MainViewController

@synthesize collectionView, item;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.userWord = [[NSArray alloc] init];
    [RequestObject requestMainData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSLog(@"view did load");
    
    //xib 지정
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellStyle" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(homeviewCollectionReload:)
                                                      name:MainNotification
                                                    object:nil];
    
<<<<<<< HEAD
    //사진이름, 사진 배열
    self.photoName =
    @[@"Petco Park",@"bye bye",@"ME",@"HUT",@"IN N OUT",@"Yeah ~",@"Fuck",@"Sky View",@"BaseBall",@"Bumgarner",@"Sana"];
    
    self.photoDetail =
    @[@"sandiego baseballpark",@"good bye here",@"kim geon hui",@"snow picture",@"california usa",@"drink drink",@"jot e na gga",@"japan airline",@"sandiego vs sanfransico",@"sanfransico picter",@"i love you"];
    
    self.photo =
    @[@"sample1",@"sample2",@"sample3",@"sample4",@"sample5",@"sample6",@"sample7",@"sample8",@"sample9",@"sample10",@"sample11"];
    
=======

    [self collectionSizeFix];
>>>>>>> ddd464469f3d478dcc76ab845946a08a73844d74
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setHidden:YES];
}

#pragma mark - cell setting
//세션 갯수
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//로우 갯수
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"self.userWord.count %ld",self.userWord.count);
    return self.userWord.count;
}

//셀 셋팅
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *wordDic =  [self.userWord objectAtIndex:indexPath.row];
    NSString *title = [wordDic objectForKey:@"title"];
    
    NSArray *imageArray = [wordDic objectForKey:@"photos"];
    
    NSDictionary *imageURL = imageArray[0];
    
    NSURL *url = [NSURL URLWithString:[imageURL objectForKey:@"image"]];
    
    [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home"]];
    cell.nameLabel.text = title;
    
    return cell;
}

//셀 크기
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.bounds.size.width / 1), self.view.bounds.size.height / 3);
}

//컬렉션과 컬렉션 width 간격, 내부여백
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//셀간의 최소간격
//위아래 간격 hight
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


//셀 선택시
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" cell number : %ld", indexPath.row);

    //선택시 구동
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

<<<<<<< HEAD
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 3.0f;
=======
    //사진갯수 1 ~ 3
    if ( self.userWord.count < 4) {
        if (cell.bounds.size.height >= 400) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
        
    //사진갯수 4 ~ 6
    }else if ( self.userWord.count < 7 ){
        if (cell.bounds.size.height >= 300) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
        
    //사진갯수 7 ~ 9
    }else if ( self.userWord.count < 10 ){
        if (cell.bounds.size.height >= 250) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
        
    //사진객수 10 ~ 11
    }else {
        if (cell.bounds.size.height >= 220) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
    };
    
//    UIStoryboard *stotyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
//    UIViewController *readScreen = [stotyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
//    [self.navigationController pushViewController:readScreen animated:YES];
>>>>>>> ddd464469f3d478dcc76ab845946a08a73844d74
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
    UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
    [self.navigationController pushViewController:readScreen animated:YES];
}

//셀을 다시 선택했을 경우
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = nil;
    cell.layer.borderWidth = 0.0f;
}

<<<<<<< HEAD
=======
//collection size fix
- (void)collectionSizeFix {
    
    switch ( self.userWord.count ) {
        case 1:
            self.maxRatio = 0.7;
            self.minRatio = 2;
            break;
            
        case 2:
            self.maxRatio = 0.7;
            self.minRatio = 2;
            break;
            
        case 3:
            self.maxRatio = 1;
            self.minRatio = 3;
            break;
            
        case 4:
            self.maxRatio = 1.1;
            self.minRatio = 4;
            break;
            
        case 5:
            self.maxRatio = 1.2;
            self.minRatio = 5;
            break;
            
        case 6:
            self.maxRatio = 1.3;
            self.minRatio = 6;
            break;
            
        case 7:
            self.maxRatio = 1.4;
            self.minRatio = 7;
            break;
            
        case 8:
            self.maxRatio = 1.5;
            self.minRatio = 8;
            break;
            
        case 9:
            self.maxRatio = 1.5;
            self.minRatio = 9;
            break;
            
        case 10:
            self.maxRatio = 1.5;
            self.minRatio = 10;
            break;
            
        case 11:
            self.maxRatio = 1.6;
            self.minRatio = 11;
            break;
            
        case 12:
            self.maxRatio = 1.7;
            self.minRatio = 12;
            break;
    }
    
}

>>>>>>> ddd464469f3d478dcc76ab845946a08a73844d74
//homeviewCollectionReload
//네트워크에서 사진 불러오기
- (void)homeviewCollectionReload:(NSNotification *)noti
{
//    NSDictionary *wordDic = noti.userInfo;
//    self.userWord = [wordDic objectForKey:@"word"];
//    
//    NSLog(@"homeviewCollectionReload");
//    
//    for ( NSDictionary *dic in self.userWord ) {
//        
//        NSDictionary *wordDic =  [self.userWord objectAtIndex:indexPath.row];
//        NSString *title = [wordDic objectForKey:@"title"];
//        
//        NSArray *imageArray = [wordDic objectForKey:@"photos"];
//        
//        NSDictionary *imageURL = imageArray[0];
//        
//        NSURL *url = [NSURL URLWithString:[imageURL objectForKey:@"image"]];
//        
//        [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home"]];
//        cell.nameLabel.text = title;
//    }
//    
//    [self.collectionView reloadData];
}

#pragma mark - memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
