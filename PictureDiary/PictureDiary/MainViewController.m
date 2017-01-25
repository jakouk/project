//
//  MainViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "MainViewController.h"
#import "CustomCell.h"
#import "ReadViewController.h"

#import <UIImageView+WebCache.h>

@interface MainViewController ()

@property (nonatomic) NSMutableArray *userWord;

//refreshControl ( NetworkData )
@property (nonatomic) UIRefreshControl *refreshControl;

//zeroData Distinction
@property (nonatomic) UILabel *zeroData;

@end

@implementation MainViewController

@synthesize collectionView, item;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.userWord = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellStyle" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    
    [PDMainManager requestMainDataUpdateFinishDataBlock:^{
        
        [self homeviewCollectionReload];
    }];
    
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
    return self.userWord.count;
}

//make cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    // indexPath.row 7 , 17, 27 ... nextCell check
    if ( indexPath.row %10 == 7 ) {
        
        if ( self.userWord.count == indexPath.row + 3 ) {
            
            if ( [UserInfo sharedUserInfo].mainNextUrl != nil ) {
                
                MainViewController * __weak wself = self;
                
                [PDMainManager requestAddMain:[UserInfo sharedUserInfo].mainNextUrl updateFinishDataBlock:^{
                    
                    [wself addCellMethod];
                }];
                
            }
            
        }
        
    }
    
    if (self.userWord.count != 0) {
        
        //title
        NSDictionary *wordDic = [[NSDictionary alloc] init];
        wordDic = (NSDictionary *)self.userWord[indexPath.row];
        
        NSString *title =  [wordDic objectForKey:@"title"];
        cell.nameLabel.text = title;
        
        //image
        NSArray *imageArray = [wordDic objectForKey:@"photos"];
        
        if (imageArray.count != 0) {
            
            NSDictionary *imageSize = [imageArray objectAtIndex:0];
            NSDictionary *imageURL = [imageSize objectForKey:@"image"];
            NSURL *url = [NSURL URLWithString:[imageURL objectForKey:@"full_size"]];
            [cell.imageView sd_setImageWithURL:url
                              placeholderImage:[UIImage imageNamed:@"sky"]];
        } else {
            
            cell.nameLabel.tintColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    return cell;
}

//셀 크기
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.bounds.size.width / 1), self.view.bounds.size.height / 3);
}

//컬렉션과 컬렉션 width 간격, 내부여백
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//셀간의 최소간격
//위아래 간격 hight
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//셀 선택시
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //선택시 구동
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 3.0f;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
    ReadViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
    //post-id
    NSDictionary *wordDic =  [self.userWord objectAtIndex:indexPath.row];
    NSNumber *post = [wordDic objectForKey:@"id"];
    NSString *postId =  [post stringValue];
    
    NSLog(@"Read setPost Id");
    [readScreen setPostId:postId];
    [self.navigationController pushViewController:readScreen animated:YES];
    
}

//homeviewCollectionReload
//네트워크에서 사진 불러오기
- (void)homeviewCollectionReload
{
    NSDictionary *wordDic = [UserInfo sharedUserInfo].firstMainData;
    
    if ([[wordDic objectForKey:@"count"] isEqualToNumber:@0]) {
        
        CGFloat xPos = (self.view.frame.size.width - (self.view.frame.size.width/2 + 100 ))/2;
        
        self.zeroData = [[UILabel alloc] initWithFrame:CGRectMake(xPos, self.view.frame.size.height/2-self.view.frame.size.height/4, self.view.frame.size.width/2+100, self.view.frame.size.height/2)];
        
        self.zeroData.textAlignment = NSTextAlignmentCenter;
        self.zeroData.text = @" 당신의 이야기를 들려주세요 ";
        
        [self.view addSubview:self.zeroData];
        
        // 데이터가 있다가 모든 데이터가 사라지면
        if (self.refreshControl != nil) {
            
            self.refreshControl = nil;
            for(UIView *subview in [self.collectionView subviews])
            {
                if([subview isKindOfClass:[UIRefreshControl class]])
                {
                    [subview removeFromSuperview];
                }
            }
            
        }
        
        [self.userWord removeAllObjects];
        [self.collectionView reloadData];
        
    } else if ([wordDic objectForKey:@"results"] != nil ) {
        
        //zeroData가 nil인 경우는 실행 안하고 nil이 아닌경우는 제거함
        if (self.zeroData != nil) {
            
            //UIView의 자식중 UILabel 삭제
            for(UIView *subview in [self.view subviews])
            {
                if([subview isKindOfClass:[UILabel class]])
                {
                    [subview removeFromSuperview];
                }
            }
        }
        
        //refreshControl은 1개만 추가되도록 하기 위한 구문 
        if (self.refreshControl == nil) {
            
            self.refreshControl = [[UIRefreshControl alloc] init];
            self.refreshControl.tintColor = [UIColor grayColor];
            [self.refreshControl addTarget:self action:@selector(refershControlAction) forControlEvents:UIControlEventValueChanged];
            
            [self.collectionView addSubview:self.refreshControl];
            self.collectionView.alwaysBounceVertical = YES;
        }

        [self.userWord removeAllObjects];
        [self.userWord addObjectsFromArray:[wordDic objectForKey:@"results"]];
        [UserInfo sharedUserInfo].mainNextUrl = [wordDic objectForKey:@"next"];
        [self.collectionView reloadData];

    }
}

//add Cell Method
- (void)addCellMethod {
    
    NSDictionary *wordDic = [UserInfo sharedUserInfo].wordDic;
    [self.userWord addObjectsFromArray:[wordDic objectForKey:@"results"]];
    [UserInfo sharedUserInfo].mainNextUrl = [wordDic objectForKey:@"next"];
    [self.collectionView reloadData];
    
}

#pragma mark - memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//pull to reFresh
- (void)refershControlAction{
    
    [PDMainManager requestMainDataUpdateFinishDataBlock:^{
        [self homeviewCollectionReload];
    }];
    
    [self.refreshControl endRefreshing];
    
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
