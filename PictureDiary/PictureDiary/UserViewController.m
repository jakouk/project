//
//  UserViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"

@interface UserViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *userTableView;

@property NSDictionary *userNameDic;
@property NSDictionary *emailDic;
@property NSDictionary *idDataDic;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.userTableView setDelegate:self];
    [self.userTableView setDataSource:self];
    
    [self tableviewFrameSize];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDataRoad:)
                                                 name:UserInfoNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logoutViewChangeMethod:)
                                                 name:LogoutNotification
                                               object:nil];
}

#pragma mark - tableview setting
//frame size
- (void)tableviewFrameSize
{
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.userTableView.frame.size.width,
                                                                  self.userTableView.frame.size.height)];
    [footerview setBackgroundColor:[UIColor clearColor]];
    [self.userTableView setTableFooterView:footerview];
    
}

//session
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        //사용자 이름
        if (indexPath.row == 0) {
            NSString *userName = [self.userNameDic objectForKey:@"username"];
            
            [cell.imageView setImage:[UIImage imageNamed:@"usericon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            [cell.textLabel setText:@"사용자 이름"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",userName]];
            NSLog(@"username : %@",userName);
        }
        
        //사다리 계정
        if (indexPath.row == 1) {
            NSString *email = [self.emailDic objectForKey:@"email"];
            
            [cell.imageView setImage:[UIImage imageNamed:@"Emailicon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            [cell.textLabel setText:@"계정 e-mail"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",email]];
            NSLog(@"email : %@",email);
        }
        
        //id
        if (indexPath.row == 2) {
            NSString *idString = [self.idDataDic objectForKey:@"id"];
            
            [cell.imageView setImage:[UIImage imageNamed:@"Facebookicon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            [cell.textLabel setText:@"ID"];
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%@",idString]];
            NSLog(@"idstring : %@",idString);
        }
//
//        //전화번호
//        if (indexPath.row == 3) {
//            [cell.imageView setImage:[UIImage imageNamed:@"Phoneicon"]];
//            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
//            [cell.textLabel setText:@"연락처"];
//            [cell.detailTextLabel setText:@"010 - 1234 - 5678"];
//        }
    }
    
    return cell;
}

//cell height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

//header
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headerString = [NSString stringWithFormat:@"프로필"];
    return headerString;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

#pragma mark - logout button
- (IBAction)logoutButtonAction:(id)sender
{
    
    //로그아웃 확인 얼럿
    UIAlertController *logoutAlert = [UIAlertController alertControllerWithTitle:@"Log Out"
                                                                         message:@"정말 로그아웃 하시겠어요?"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"확인"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * _Nonnull action) {
                                                   NSLog(@"로그아웃 허가");
                                                   [RequestObject requestLogoutData];
                                                   
                                               }];
    
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"취소"
                                                 style:UIAlertActionStyleDestructive
                                               handler:nil];
    
    [logoutAlert addAction:ok];
    [logoutAlert addAction:no];
    
    [self presentViewController:logoutAlert animated:YES completion:nil];
}

#pragma mark - network
- (void)userDataRoad:(NSNotification *)noti
{
    NSDictionary *wordDic = noti.userInfo;
    self.userNameDic = [wordDic objectForKey:@"username"];
    self.emailDic = [wordDic objectForKey:@"email"];
    self.idDataDic = [wordDic objectForKey:@"id"];
    
    [self.userTableView reloadData];
}

#pragma mark - memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)logoutViewChangeMethod:(NSNotification *)noti {
    
    // MainTabBarController로 이동
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *LoginView = [storyBoard instantiateInitialViewController];
    UIApplication *application = [UIApplication sharedApplication];
    UIWindow *window = [application.delegate window];
    window.rootViewController = LoginView;
    [window makeKeyAndVisible];
    
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
