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
#define defaultMinRatio 11   //사진갯수와 동일하거나 위아래로 3차이 확실히 비율이 맞음
#define defaultMaxRatio 1.6 //사진갯수가 적어지면 아래로 많아지면 높게 설정

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
    
    //xib 지정
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellStyle" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    /*afterDelay : 메시지를 보내기 전의 최소 시간입니다.
     지연 0을 지정해도 선택기가 즉시 수행되는 것은 아닙니다.
     선택기는 여전히 스레드의 실행 루프에 대기하여 가능한 한 빨리 수행됩니다.
     */
    [self performSelector:@selector(quickFix) withObject:nil afterDelay:0.01];
    
    //사진이름, 사진 배열
    self.photoName = @[@"Petco Park",@"bye bye",@"ME",@"HUT",@"IN N OUT",@"Yeah ~",@"Fuck",@"Sky View",@"BaseBall",@"Bumgarner",@"Sana"];
    self.photoDetail = @[@"sandiego baseballpark",@"good bye here",@"kim geon hui",@"snow picture",@"california usa",@"drink drink",@"jot e na gga",@"japan airline",@"sandiego vs sanfransico",@"sanfransico picter",@"i love you"];
    self.photo = @[@"sample1",@"sample2",@"sample3",@"sample4",@"sample5",@"sample6",@"sample7",@"sample8",@"sample9",@"sample10",@"sample11"];
    
}

- (void)viewDidLayoutSubviews
{
    //layout
    self.slidingLayout = [[CollectionLayout alloc] initWithMaxRatio:defaultMaxRatio andMinRatio:defaultMinRatio];
    [self.collectionView setCollectionViewLayout:self.slidingLayout];
    [self.collectionView.collectionViewLayout invalidateLayout];
    [self.collectionView setBackgroundColor:[UIColor blackColor]];
    
    //셀크기
    self.maxRatio = defaultMaxRatio;
    self.minRatio = defaultMinRatio;
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
    return YES;//defult = no
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
        cell.detailLabel.alpha = alpha;
        
        if(i > currentIndex){
            cell.nameLabel.transform = CGAffineTransformMakeScale(1 - (1 - alpha) * 0.3, 1 - (1 - alpha) * 0.3);
            cell.detailLabel.transform = CGAffineTransformMakeTranslation(0, (1 - alpha) * 30);
        }else{
            cell.nameLabel.transform = CGAffineTransformIdentity;
            cell.detailLabel.transform = CGAffineTransformIdentity;
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
    cell.detailLabel.text = self.photoDetail[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[self.photo objectAtIndex:indexPath.row]];
    
    return cell;
}

//셀 선택시
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@" cell number : %ld", indexPath.row);
    //선택시 구동
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 3.0f;
    
    //해당 셀에 대한 데이터를 글읽기화면으로 옮기고 글읽기화면 전환
    //셀 크기가 일정크기로 넘었을경우 선택되도록 일정크기에 못미칠경우 선택안되도록
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
