//
//  SearchViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "SearchViewController.h"
#import "RequestObject.h"
#import <UIImageView+WebCache.h>
#import "CustomCell.h"
#import "ReadViewController.h"

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *mainCollection;
@property (weak, nonatomic) IBOutlet UITextField *searchData;

@property NSMutableArray *searchArray;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self.mainCollection registerNib:[UINib nibWithNibName:@"CellStyle" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cell"];
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    self.searchArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setHidden:YES];
    
}

//cell numbers
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.searchArray.count;
}

//make cell
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.row %10 == 7 ) {
        
        if ( self.searchArray.count == indexPath.row + 3 ) {
            
            if ( [UserInfo sharedUserInfo].mainNextUrl != nil ) {
                
                SearchViewController * __weak wself = self;
                
                [RequestObject reqeustAddSearch:[UserInfo sharedUserInfo].searchNextUrl updateFinishDataBlock:^{
                    [wself addCellMethod];
                }];
                
            }
            
        }
        
    }
    
    CustomCell *cell = (CustomCell *)[self.mainCollection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [cellImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    if (self.searchArray.count != 0) {
        //title
        NSDictionary *wordDic = [[NSDictionary alloc] init];
        wordDic = (NSDictionary *)[self.searchArray objectAtIndex:indexPath.row];
        
        NSString *title =  [wordDic objectForKey:@"title"];
        cell.nameLabel.text = title;
        
        //image
        NSArray *imageArray = [wordDic objectForKey:@"photos"];
        
        if (imageArray.count != 0) {
            
            NSDictionary *imageSize = [imageArray objectAtIndex:0];
            NSDictionary *imageURL = [imageSize objectForKey:@"image"];
            NSURL *url = [NSURL URLWithString:[imageURL objectForKey:@"medium_square_crop"]];
            [cell.imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home"]];
            
            
        } else {
            
            cell.backgroundColor = [UIColor whiteColor];
            
        }
    }
    
    return cell;
}



//cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( (self.view.frame.size.width-20)/2- 5, (self.view.frame.size.width-20)/2- 5);
}

//inside padding
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//cell spacing
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


//searchButton Click
- (IBAction)touchupInsideSearchButton:(UIButton *)sender {
    
    [self.searchData resignFirstResponder];
    NSString *searchData = self.searchData.text;
    SearchViewController * __weak wself = self;
    [RequestObject requestSearch:searchData updateFinishDataBlock:^{
        [wself searchCollectionViewReload];
    }];
}

- (void)searchCollectionViewReload {

    NSDictionary *searchData = [[NSDictionary alloc] init];
    searchData = [UserInfo sharedUserInfo].searchData;
    
    NSLog(@" SearchViewController = %@",searchData);
    
    if ([searchData objectForKey:@"results"] != nil ) {
        
        NSLog(@"SearchViewController searchCollectionViewReload");
        [self.searchArray removeAllObjects];
        [self.searchArray addObjectsFromArray:[searchData objectForKey:@"results"]];
        NSLog(@"SearchViewController self.searchArray.count = %ld",self.searchArray.count);
        
        [UserInfo sharedUserInfo].searchNextUrl = [searchData objectForKey:@"next"];
        [self.mainCollection reloadData];
    }
    
}

//selected cell
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //선택시 구동
    UICollectionViewCell *cell = [self.mainCollection cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.layer.borderWidth = 3.0f;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
    ReadViewController *readScreen = [storyboard instantiateViewControllerWithIdentifier:@"ReadViewController"];
    
    //post-id
    NSDictionary *wordDic =  [self.searchArray objectAtIndex:indexPath.row];
    NSNumber *post = [wordDic objectForKey:@"id"];
    NSString *postId =  [post stringValue];
    
    NSLog(@"Read setPost Id");
    [readScreen setPostId:postId];
    [self.navigationController pushViewController:readScreen animated:YES];
    
}

- (void)addCellMethod{
    
    NSDictionary *wordDic = [UserInfo sharedUserInfo].searchData;
    [self.searchArray addObjectsFromArray:[wordDic objectForKey:@"results"]];
    [UserInfo sharedUserInfo].searchNextUrl = [wordDic objectForKey:@"next"];
    [self.mainCollection reloadData];
    
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
