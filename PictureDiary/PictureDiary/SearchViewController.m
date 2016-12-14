//
//  SearchViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "SearchViewController.h"
#import "RequestObject.h"

@interface SearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollection;
@property (weak, nonatomic) IBOutlet UITextField *searchData;

//join Test
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *pass;
@property (weak, nonatomic) IBOutlet UITextField *username;


//login test
@property (weak, nonatomic) IBOutlet UITextField *loginEmail;
@property (weak, nonatomic) IBOutlet UITextField *loginPass;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(joinMethod:)
//                                                 name:JoinNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginMethod:)
//                                                 name:LoginNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mainMehtod:)
//                                                 name:MainNotification
//                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//cell numbers
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
         UICollectionViewCell *cell = [self.mainCollection dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    
    [cellImageView setContentMode:UIViewContentModeScaleAspectFit];
    [cellImageView setImage:[UIImage imageNamed:@"home"]];
    
    [cell addSubview:cellImageView];

    return cell;
}



//셀 크기 기정
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake( (self.view.frame.size.width-20)/2- 5, (self.view.frame.size.width-20)/2- 5);
}

//내부 여백
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//셀간의 최소간격
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


//searchButton Click
- (IBAction)touchupInsideSearchButton:(UIButton *)sender {
    
    
}



//network Test
- (IBAction)networkTest:(UIButton *)sender {
    
    [RequestObject requestMainData];

}

//join Test
- (IBAction)joinTest:(UIButton *)sender {
    
    NSString *userId = self.email.text;
    NSString *userName = self.username.text;
    NSString *pass = self.pass.text;
    [RequestObject requestJoinData:userId userPass:pass userName:userName];
}

//login Test
- (IBAction)loginTest:(UIButton *)sender {
    
    NSString *userId = self.loginEmail.text;
    NSString *pass = self.loginPass.text;
    [RequestObject requestLoginData:userId userPass:pass];
}

//joinMehtod
- (void)joinMethod:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    
    NSLog(@"%@",dic);
    
    if ( [dic objectForKey:@"username"] == nil  && [dic objectForKey:@"password"] == nil) {
        NSLog(@" 가입 실패 이미 존재하는 이메일 ");
    } else if ( [dic objectForKey:@"email"] == nil && [dic objectForKey:@"password"] == nil) {
        NSLog(@" 가입 실패 이미 존재하는 유저네임 ");
    } else {
        NSLog(@" 가입 성공 ");
    }
    
}

//loginMethod
- (void)loginMethod:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    
    NSLog(@"%@",dic);
    
    if ( [dic objectForKey:@"key"] == NULL ) {
        NSLog(@"로그인 실패");
    } else {
        NSLog(@"로그인 성공");
        [UserInfo sharedUserInfo].userToken = [dic objectForKey:@"key"];
    }
    
}

//mainMethod
- (void)mainMehtod:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    
    NSLog(@"%@",dic);
    
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
