//
//  MainViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "MainViewController.h"
#import "CustomCell.h"
#import "CollectionLayout.h"
//#import <AssetsLibrary/AssetsLibrary.h>

//셀 비율
//#define defaultMinRatio 11   //사진갯수와 동일하거나 위아래로 3차이 확실히 비율이 맞음
//#define defaultMaxRatio 1.6 //사진갯수가 적어지면 아래로 많아지면 높게 설정

@interface MainViewController ()

//사진제목
@property NSArray *photoName;

//사진내용
@property NSArray *photoDetail;

//사진
@property NSArray *photo;

//레이아웃
@property CollectionLayout *slidingLayout;

//셀의 크기
@property CGFloat minRatio;
@property CGFloat maxRatio;

@end

@implementation MainViewController

@synthesize collectionView, item;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"view did load");
    
    //xib 지정
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellStyle" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    /*afterDelay : 메시지를 보내기 전의 최소 시간입니다.
     지연 0을 지정해도 선택기가 즉시 수행되는 것은 아닙니다.
     선택기는 여전히 스레드의 실행 루프에 대기하여 가능한 한 빨리 수행됩니다.
     */
    [self performSelector:@selector(quickFix) withObject:nil afterDelay:0.01];
    
    //사진이름, 사진 배열
    self.photoName =
    @[@"Petco Park",@"bye bye",@"ME",@"HUT",@"IN N OUT",@"Yeah ~",@"Fuck",@"Sky View",@"BaseBall",@"Bumgarner",@"Sana"];
    
    self.photoDetail =
    @[@"sandiego baseballpark",@"good bye here",@"kim geon hui",@"snow picture",@"california usa",@"drink drink",@"jot e na gga",@"japan airline",@"sandiego vs sanfransico",@"sanfransico picter",@"i love you"];
    
    self.photo =
    @[@"sample1",@"sample2",@"sample3",@"sample4",@"sample5",@"sample6",@"sample7",@"sample8",@"sample9",@"sample10",@"sample11"];
    NSLog(@"array count : %ld", self.photo.count);
    
    switch (self.photo.count) {
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

- (void)viewDidLayoutSubviews
{
    NSLog(@"view did layout sub view");
    
    //layout
    self.slidingLayout = [[CollectionLayout alloc] initWithMaxRatio:self.maxRatio andMinRatio:self.minRatio];
    [self.collectionView setCollectionViewLayout:self.slidingLayout];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setBackgroundColor:[UIColor blackColor]];
    
    //셀크기
//    self.maxRatio = defaultMaxRatio;
//    self.minRatio = defaultMinRatio;
}

#pragma mark - qick fix
//뷰에 진입시 컬렉션 뷰 고정위치
-(void)quickFix
{
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y + 1)];
}

//이 View Controller에 대한 상태 표시 줄 변경에 사용해야하는 애니메이션 유형을 반환하도록 재정의합니다.
//현재는 prefersStatusBarHidden에 대한 변경 사항에만 영향을 미칩니다.
-(BOOL)prefersStatusBarHidden
{
    return YES; //defult = no
}

#pragma mark - cell layout
-(void)layoutSubviewsWithAttributes:(NSMutableArray *)theAttributes
{
    for(int i = 0; i < theAttributes.count; i++){
        
        CustomCell *cell = (CustomCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        //
        CGFloat maxHeight = self.collectionView.bounds.size.width / self.maxRatio;
        CGFloat minHeight = self.collectionView.bounds.size.width / self.minRatio;
        //
        CGFloat cellHeight = (maxHeight * 0.5 + minHeight * 0.5);
        CGFloat currentIndex = self.collectionView.contentOffset.y / cellHeight;
        
        CGFloat ratio = cell.bounds.size.width / cell.bounds.size.height;
        CGFloat maxDiff = self.minRatio - self.maxRatio;
        CGFloat diff = self.minRatio - ratio;
        
        CGFloat alpha = diff/maxDiff;
        
        cell.overView.alpha = 1 - alpha;
        cell.nameLabel.alpha = alpha;
//        cell.detailLabel.alpha = alpha;
        
//        NSLog(@"cell height : %lf", cell.bounds.size.height);
        
        if(i > currentIndex){
            cell.nameLabel.transform = CGAffineTransformMakeScale(1 - (1 - alpha) * 0.3, 1 - (1 - alpha) * 0.3);
//            cell.detailLabel.transform = CGAffineTransformMakeTranslation(0, (1 - alpha) * 30);
        }else{
            cell.nameLabel.transform = CGAffineTransformIdentity;
//            cell.detailLabel.transform = CGAffineTransformIdentity;
        }
    }
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
    return self.photo.count;
}

//셀 셋팅
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.nameLabel.text = self.photoName[indexPath.row];
//    cell.detailLabel.text = self.photoDetail[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.photo objectAtIndex:indexPath.row]];
    
    return cell;
}

//셀 선택시
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" cell number : %ld", indexPath.row);

    //선택시 구동
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSLog(@"cell height : %lf", cell.bounds.size.height);

    //사진갯수 1 ~ 3
    if (self.photo.count == 1 || self.photo.count == 2 || self.photo.count == 3) {
        if (cell.bounds.size.height >= 400) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
        
    //사진갯수 4 ~ 6
    }else if (self.photo.count == 4 || self.photo.count == 5 || self.photo.count == 6){
        if (cell.bounds.size.height >= 300) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
        
    //사진갯수 7 ~ 9
    }else if (self.photo.count == 7 || self.photo.count == 8 || self.photo.count == 9){
        if (cell.bounds.size.height >= 250) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
        
    //사진객수 10 ~ 11
    }else if (self.photo.count == 10 || self.photo.count == 11){
        if (cell.bounds.size.height >= 240) {
            NSLog(@"cell height : %lf", cell.bounds.size.height);
            
            cell.layer.borderColor = [UIColor whiteColor].CGColor;
            cell.layer.borderWidth = 3.0f;

            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
            UIViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
            [self.navigationController pushViewController:readScreen animated:YES];
        };
    };
}

//셀을 다시 선택했을 경우
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = nil;
    cell.layer.borderWidth = 0.0f;
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
