//
//  ReadViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "ReadViewController.h"
#import <UIImageView+WebCache.h>
#import "MainViewController.h"

@interface ReadViewController ()
<UIScrollViewDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

//제목라벨, 내용
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextView *contentText;

@property NSMutableArray *imageList;
@property NSDictionary *wordDic;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.contentText.editable = NO;
    
    [RequestObject requestReadData:self.postId];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestReadViewChange:)
                                                 name:ReadNotification
                                               object:nil];
    
    [self.navigationController.navigationBar setHidden:NO];
    
    UIBarButtonItem *modifiedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                                    target:self action:@selector(touchinsideModifiedButton)];
    
    [self.navigationItem setRightBarButtonItem:modifiedButton];
    
    self.imageList = [[NSMutableArray alloc] init];
    
    //textview
    self.contentText.delegate = self;
    
    //ScrollView에 필요한 옵션을 적용한다.
    //vertical = 세로 , Horizontal = 가로 스크롤효과를 적용.
    self.imageScrollView.showsVerticalScrollIndicator = NO;
    self.imageScrollView.showsHorizontalScrollIndicator = YES;
    
    // 스크롤이 경계에 도달하면 바운싱효과를 적용
    self.imageScrollView.alwaysBounceVertical = NO;
    self.imageScrollView.alwaysBounceHorizontal = NO;
    
    //페이징 가능 여부 YES
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.delegate = self;
    
    //pageControl에 필요한 옵션을 적용한다.
    //현재 페이지 index는 0
    self.pageControl.currentPage = 0;
    self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    
    //페이지 갯수
    self.pageControl.numberOfPages = self.imageList.count;
    
    //페이지 컨트롤 값변경시 이벤트 처리 등록
    [self.pageControl addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
}


- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.wordDic = [[NSDictionary alloc] init];
}

//스크롤이 변경될때 page의 currentPage 설정
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    self.pageControl.currentPage = self.imageScrollView.contentOffset.x / self.imageScrollView.frame.size.width;
}

//페이지 컨트롤 값이 변경될때, 스크롤뷰 위치 설정
- (void) pageChangeValue:(id)sender
{
    UIPageControl *pControl = (UIPageControl *) sender;
    [self.imageScrollView setContentOffset:CGPointMake(pControl.currentPage * 320, 0) animated:YES];
}

// 스크롤바를 보였다가 사라지게 함
- (void)viewDidAppear:(BOOL)animated
{
    [self.imageScrollView flashScrollIndicators];
}

#pragma mark - modified button
//edit button
- (void)touchinsideModifiedButton
{
    UIAlertController *manuAlert = [UIAlertController alertControllerWithTitle:@"메뉴"
                                                                       message:@"원하시는 메뉴를 선택해주십시오."
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *contentModified = [UIAlertAction actionWithTitle:@"글 수정"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                                                                //수정화면으로 화면전환
                                                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Read" bundle:nil];
                                                                UIViewController *modifiedScreen = [storyboard instantiateViewControllerWithIdentifier:@"ModifyController"];
                                                                [self.navigationController pushViewController:modifiedScreen animated:YES];
                                                                
                                                            }];
    
    UIAlertAction *contentDelete = [UIAlertAction actionWithTitle:@"글 삭제"
                                                            style:UIAlertActionStyleDestructive
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              //글 삭제
                                                              UIAlertController *deleteAlert = [UIAlertController alertControllerWithTitle:@"글 삭제"
                                                                                                                                   message:@"이 글을 영구적으로 삭제하시겠어요?"
                                                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                                              
                                                              UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"글 삭제" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                  [RequestObject requestDeleteData:self.postId pdateFinishDataBlock:^{
                                                                      [self afterDeleteViewChangeMehtod];
                                                                  }];
                                                              }];
                                                              
                                                              UIAlertAction *deleteActionCancel = [UIAlertAction actionWithTitle:@"취소"
                                                                                                                           style:UIAlertActionStyleCancel
                                                                                                                         handler:nil];
                                                              
                                                              [deleteAlert addAction:deleteAction];
                                                              [deleteAlert addAction:deleteActionCancel];
                                                              [self presentViewController:deleteAlert animated:YES completion:nil];
                                                              
                                                          }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"취소"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [manuAlert addAction:contentModified];
    [manuAlert addAction:contentDelete];
    [manuAlert addAction:cancel];
    [self presentViewController:manuAlert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//오토레이아웃 잡고 노티 받기
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    [RequestObject requestReadData:self.postId];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(requestReadViewChange:)
//                                                 name:ReadNotification
//                                               object:nil];
    
    NSInteger imageCount = self.imageList.count;
    
    //photosArray
    CGFloat imagePointWidth = self.imageScrollView.frame.size.width;
    CGFloat imagePointHeight = self.imageScrollView.frame.size.height;
    
    [self.imageScrollView setContentSize:CGSizeMake(imagePointWidth * imageCount, +  imagePointHeight)];
    
    for ( NSInteger i = 0; i < imageCount ; i ++ ) {
        
        NSDictionary *photos  = [self.imageList objectAtIndex:i];
        NSDictionary *image = [photos objectForKey:@"image"];
        NSURL *url = [NSURL URLWithString:[image objectForKey:@"full_size"]];
        
        UIImageView *fullSizeImage = [[UIImageView alloc] init];
        [fullSizeImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home"]];
        
        [fullSizeImage setFrame:CGRectMake(imagePointWidth * i, 0,
                                           imagePointWidth, imagePointHeight)];
        
        [fullSizeImage setContentMode:UIViewContentModeScaleToFill];
        [self.imageScrollView addSubview:fullSizeImage];
        
    }
    
    //페이지 갯수
    self.pageControl.numberOfPages = self.imageList.count;
    
    //페이지 컨트롤 값변경시 이벤트 처리 등록
    [self.pageControl addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)requestReadViewChange:(NSNotification *)noti {
    
        NSDictionary *wordDictionary = noti.userInfo;
        self.titleLabel.text = [wordDictionary objectForKey:@"title"];
        self.contentText.text = [wordDictionary objectForKey:@"content"];
    
        self.imageList = [wordDictionary objectForKey:@"photos"];
//        NSInteger imageCount = self.imageList.count;
//    
//        //photosArray
//        CGFloat imagePointWidth = self.imageScrollView.frame.size.width;
//        CGFloat imagePointHeight = self.imageScrollView.frame.size.height;
//    
//        [self.imageScrollView setContentSize:CGSizeMake(imagePointWidth * imageCount, +  imagePointHeight)];
//    
//        for ( NSInteger i = 0; i < imageCount ; i ++ ) {
//        
//                NSDictionary *photos  = [self.imageList objectAtIndex:i];
//                NSDictionary *image = [photos objectForKey:@"image"];
//                NSURL *url = [NSURL URLWithString:[image objectForKey:@"full_size"]];
//        
//                UIImageView *fullSizeImage = [[UIImageView alloc] init];
//                [fullSizeImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home"]];
//        
//                [fullSizeImage setFrame:CGRectMake(imagePointWidth * i, 0,
//                                                imagePointWidth, imagePointHeight)];
//        
//                [fullSizeImage setContentMode:UIViewContentModeScaleToFill];
//                [self.imageScrollView addSubview:fullSizeImage];
//            
//        }
//    
//    //페이지 갯수
//    self.pageControl.numberOfPages = self.imageList.count;
//    
//    //페이지 컨트롤 값변경시 이벤트 처리 등록
//    [self.pageControl addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)afterDeleteViewChangeMehtod {
    
    UIViewController *firstViewController = self.navigationController.viewControllers.firstObject;
    
    if ([firstViewController class] == [MainViewController class] ) {
        
        [RequestObject requestMainData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//텍스트뷰
//키보드 활성화 안되도록 설정
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
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
