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
#import "ReadViewController.h"

#import <UIImageView+WebCache.h>

@interface MainViewController ()

@property NSArray *userWord;

@end

@implementation MainViewController

@synthesize collectionView, item;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.userWord = [[NSArray alloc] init];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //xib 지정
    [self.collectionView registerNib:[UINib nibWithNibName:@"CellStyle" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    [RequestObject requestMainData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(homeviewCollectionReload:)
                                                      name:MainNotification
                                                    object:nil];
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
    return self.userWord.count;
}

//셀 셋팅
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (self.userWord.count != 0) {
        
        //title
//        NSDictionary *wordDic =  self.userWord[indexPath.row];
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
            [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home"]];
            
        } else {
            
            cell.backgroundColor = [UIColor blueColor];
            
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
    NSString *postId =  [NSString stringWithFormat:@"%@",[wordDic objectForKey:@"id"]];
    
    NSLog(@"Read setPost Id");
    [readScreen setPostId:postId];
    [self.navigationController pushViewController:readScreen animated:YES];

}

//selectedCell segue
- (void)performSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"readSegue"]) {
        
    }
    
}


//셀을 다시 선택했을 경우
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = nil;
    cell.layer.borderWidth = 0.0f;
}

//homeviewCollectionReload
//네트워크에서 사진 불러오기
- (void)homeviewCollectionReload:(NSNotification *)noti
{
    NSDictionary *wordDic = noti.userInfo;
    self.userWord = [wordDic objectForKey:@"results"];
    
    [self.collectionView reloadData];
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
