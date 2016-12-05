//
//  ReadViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()
<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *photoScrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;

@property NSArray *imageList;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageList = @[@"sample1",@"sample2",@"sample3",@"sample4",@"sample5",@"sample6",@"sample7",@"sample8",@"sample9",@"sample10",@"sample11"];

    //ScrollView에 필요한 옵션을 적용한다.
    //vertical = 세로 , Horizontal = 가로 스크롤효과를 적용.
    self.photoScrollView.showsVerticalScrollIndicator = NO;
    self.photoScrollView.showsHorizontalScrollIndicator = YES;
    
    // 스크롤이 경계에 도달하면 바운싱효과를 적용
    self.photoScrollView.alwaysBounceVertical = NO;
    self.photoScrollView.alwaysBounceHorizontal = NO;
    
    //페이징 가능 여부 YES
    self.photoScrollView.pagingEnabled = YES;
    self.photoScrollView.delegate = self;
    
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

//오토레이아웃 적용 후 뷰 로드
- (void)viewDidLayoutSubviews
{
    
    NSInteger i = self.imageList.count;
    for (NSInteger i = 0; i < self.imageList.count; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(self.photoScrollView.frame.size.width * i, 0,
                                       self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height)];
        
        [imageView setImage:[UIImage imageNamed:[self.imageList objectAtIndex:i]]];
        [imageView setContentMode:UIViewContentModeScaleToFill];
        [self.photoScrollView addSubview:imageView];
    }
    
    [self.photoScrollView setContentSize:CGSizeMake(self.photoScrollView.frame.size.width * i,
                                                    self.photoScrollView.frame.size.height)];
}

//스크롤이 변경될때 page의 currentPage 설정
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    self.pageControl.currentPage = self.photoScrollView.contentOffset.x / self.photoScrollView.frame.size.width;
}

//페이지 컨트롤 값이 변경될때, 스크롤뷰 위치 설정
- (void) pageChangeValue:(id)sender
{
    UIPageControl *pControl = (UIPageControl *) sender;
    [self.photoScrollView setContentOffset:CGPointMake(pControl.currentPage * 320, 0) animated:YES];
}

// 스크롤바를 보였다가 사라지게 함
- (void)viewDidAppear:(BOOL)animated
{
    [self.photoScrollView flashScrollIndicators];
}

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
