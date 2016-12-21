//
//  LoginViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "LoginViewController.h"
#import "JoinViewController.h"
#import "MainTabBarController.h"
#import "UserInfo.h"
#import "RequestObject.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface LoginViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITextField *emailTextField;
@property (nonatomic) UITextField *passwordTextField;
@property (nonatomic) UIButton *emailLoginButton;
@property (nonatomic) UIButton *fbLoginButton;
@property (nonatomic) UIButton *joinButton;

@end


@implementation LoginViewController

#pragma mark -
#pragma mark View Controller Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createLayoutSubview];
    [self registerForKeyboardNotifications];
    
    // 로그인시 네트워크와의 통신 가능 여부 확인하는 노티피케이션
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogin:)
                                                 name:LoginNotification
                                               object:nil];
    
    // 페이스북 로그인 버튼 클릭시 액션
    [self.fbLoginButton addTarget:self
                           action:@selector(onTouchupInsideFbLoginButton:)
                 forControlEvents:UIControlEventTouchUpInside];
}


- (void)viewWillAppear:(BOOL)animated {
    
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    [self unregisterForKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginNotification object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Create Subviews

- (void)createLayoutSubview {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.9)];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self createJoinButton];
    [self createLoginButtons];
    [self createTitle];
    [self createInputTextFields];
}

- (void)createTitle {
    
    UIImageView *titleLogo =
    [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-32, self.view.frame.size.height*0.22, 64, 64)];
    [titleLogo setImage:[UIImage imageNamed:@"ladder-128"]];
    [self.scrollView addSubview:titleLogo];
    
}

- (void)createInputTextFields {
    
    self.emailTextField =
    [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.525, self.view.frame.size.width*0.8, self.view.frame.size.height*0.06)];
    self.emailTextField.borderStyle = UITextBorderStyleNone;
    self.emailTextField.textColor = [UIColor whiteColor];
    self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.passwordTextField =
    [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.615, self.view.frame.size.width*0.8, self.view.frame.size.height*0.06)];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.passwordTextField.textColor = [UIColor whiteColor];
    
    
    // placeholder custom
    self.emailTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@" 이메일"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]
                                                 }
     ];
    self.passwordTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@" 비밀번호"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]
                                                 }
     ];
    
    
    // textfield bottom line
    const CGFloat borderWidth = 2;
    CALayer *emailBottomBorder = [CALayer layer];
    emailBottomBorder.borderColor = [UIColor whiteColor].CGColor;
    emailBottomBorder.frame =
    CGRectMake(0,self.emailTextField.frame.size.height - borderWidth,self.emailTextField.frame.size.width,1);
    emailBottomBorder.borderWidth = borderWidth;
    [self.emailTextField.layer addSublayer:emailBottomBorder];
    [self.scrollView addSubview:self.emailTextField];
    
    CALayer *passwordBottomBorder = [CALayer layer];
    passwordBottomBorder.borderColor = [UIColor whiteColor].CGColor;
    passwordBottomBorder.frame =
    CGRectMake(0,self.passwordTextField.frame.size.height - borderWidth,self.passwordTextField.frame.size.width,1);
    passwordBottomBorder.borderWidth = borderWidth;
    [self.passwordTextField.layer addSublayer:passwordBottomBorder];
    [self.scrollView addSubview:self.passwordTextField];
    
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
}


- (void)createLoginButtons {
    
    self.emailLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emailLoginButton setFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.7, self.view.frame.size.width*0.8, self.view.frame.size.height*0.07)];
    [self.emailLoginButton setImage:[UIImage imageNamed:@"email-12-16"] forState:UIControlStateNormal];
    [self.emailLoginButton setTitle:@"  이메일로 로그인" forState:UIControlStateNormal];
    [self.emailLoginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.emailLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.emailLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.emailLoginButton.layer.borderWidth = 2.0f;
    self.emailLoginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.emailLoginButton.layer.cornerRadius = 10.0f;
    [self.emailLoginButton addTarget:self
                              action:@selector(onTouchupInsideLoginButton:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.emailLoginButton];
    
    self.fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbLoginButton setFrame:CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.79, self.view.frame.size.width*0.8, self.view.frame.size.height*0.07)];
    [self.fbLoginButton setImage:[UIImage imageNamed:@"facebook-5-16"] forState:UIControlStateNormal];
    [self.fbLoginButton setTitle:@"  페이스북으로 로그인" forState:UIControlStateNormal];
    [self.fbLoginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.fbLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fbLoginButton setBackgroundColor: [UIColor colorWithRed:59.0f/255.f green:89.0f/255.f blue:152.0f/255.f alpha:1.0f]];
    self.fbLoginButton.layer.cornerRadius = 10.0f;
    [self.scrollView addSubview:self.fbLoginButton];
}

- (void)createJoinButton {
    
    self.joinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.93, self.view.frame.size.width, self.view.frame.size.height*0.07)];
    [self.joinButton setTitle:@"계정이 없으신가요?  회원가입" forState:UIControlStateNormal];
    [self.joinButton setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.3f]];
    [self.joinButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinButton addTarget:self
                        action:@selector(onTouchupInsideJoinButton:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.joinButton];
    
}



#pragma mark -
#pragma mark Actions

- (void)onTouchupInsideLoginButton:(UIButton *)sender {
    
    NSLog(@"Login Button Click");
    
    NSString *email = [NSString stringWithFormat:@"%@",self.emailTextField.text];
    NSString *password = [NSString stringWithFormat:@"%@",self.passwordTextField.text];
    
    id okHandler = ^(UIAlertAction * _Nonnull action) {
        
        self.emailTextField.text = nil;
        self.passwordTextField.text = nil;
    };
    
    UIAlertController *alert;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:okHandler];
    
    // 텍스트 필드 입력 내용 체크
    if (email.length == 0 || [email containsString:@" "] || [self checkEmail:email] == NO) {
        
        // 이메일 미입력
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"이메일을 정확하게 입력해 주세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (password.length == 0 || [password containsString:@" "]) {
        
        // 비밀번호 미입력
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"비밀번호를 정확하게 입력해 주세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        
        [RequestObject requestLoginData:email userPass:password];
    }
    
}


// 로그인시 네트워크 구현
- (void)userLogin:(NSNotification *)noti {
    
    id okHandler = ^(UIAlertAction * _Nonnull action) {
        
        self.emailTextField.text = nil;
        self.passwordTextField.text = nil;
    };
    
    UIAlertController *alert;
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:okHandler];
    
    
    NSLog(@"%@",noti);
    NSDictionary *dic = noti.userInfo;
    
    if (dic == nil) {
        
        // 네트워크가 연결되지 않은 경우
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"사용중인 네트워크 상태를 확인해 주세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([dic objectForKey:@"token"] != nil) {
        
        // 로그인에 성공한 경우
        [UserInfo sharedUserInfo].userToken = [dic objectForKey:@"token"];
        [self proceedToMain:YES];
        
    } else {
        
        // 등록되지 않은 이메일이거나 비밀번호가 틀린 경우
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"등록되지 않은 이메일이거나 이메일 또는 비밀번호를 잘못 입력하셨습니다."
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}


// MainTabBarController로 이동
- (void)proceedToMain:(BOOL)animated {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainTabBarController *mainTabBarController = [storyBoard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    window.rootViewController = mainTabBarController;
    [window makeKeyAndVisible];
    
}


- (void)onTouchupInsideFbLoginButton:(UIButton *)sender {
    
    if ([FBSDKAccessToken currentAccessToken] == nil) {
        
        // 한번도 로그인 하지 않은 사용자의 경우
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        
        [login logInWithReadPermissions:@[@"email"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                        
                                        // 로그인 후 액션
                                        if ([result.grantedPermissions containsObject:@"email"]) {
                                            NSLog(@"result : %@",result);
                                            [UserInfo sharedUserInfo].userToken = [FBSDKAccessToken currentAccessToken].tokenString;
                                            NSLog(@"%@",[FBSDKAccessToken currentAccessToken].tokenString);
                                            [self proceedToMain:YES];
                                        }
                                    }
                                }];
    } else {
        
        // 기존에 로그인했던 사용자의 로그인 후 액션
        NSLog(@"Logged in");
        [UserInfo sharedUserInfo].userToken = [FBSDKAccessToken currentAccessToken].tokenString;
        [self proceedToMain:YES];
        
    }
    
}


- (void)onTouchupInsideJoinButton:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JoinViewController *joinViewController = [storyBoard instantiateViewControllerWithIdentifier:@"JoinViewController"];
    [self presentViewController:joinViewController animated:YES completion:nil];
    
}


- (void)blankTapped:(UIControl *)sender {
    
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    
}



#pragma mark -
#pragma mark Validation

// 이메일 유효성 확인
- (BOOL)checkEmail:(NSString *)email {
    
    const char *temp = [email cStringUsingEncoding:NSUTF8StringEncoding];
    if (email.length != strlen(temp)) {
        return NO;
    }
    NSString *check = @"([0-9a-zA-Z_-]+)@([0-9a-zA-Z_-]+)(\\.[0-9a-zA-Z_-]+){1,2}";
    NSRange match = [email rangeOfString:check options:NSRegularExpressionSearch];
    if (NSNotFound == match.location) {
        return NO;
    }
    return YES;
}



#pragma mark -
#pragma mark Keyboard Notification

- (void)registerForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardChangeNotification:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveKeyboardChangeNotification:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}


- (void)unregisterForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}


- (void)didReceiveKeyboardChangeNotification:(NSNotification *)notification {
    
    if ([[notification name] isEqualToString:UIKeyboardDidShowNotification]) {
        [self.scrollView setContentOffset:CGPointMake(0, 95) animated:YES];
        
    } else if ([[notification name] isEqualToString:UIKeyboardDidHideNotification]) {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
}



#pragma mark -
#pragma mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.clearsOnBeginEditing = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UITapGestureRecognizer *blankTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blankTapped:)];
    blankTap.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:blankTap];
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.emailTextField) {
        [textField endEditing:YES];
        [self.passwordTextField becomeFirstResponder];
        
    } else if (textField == self.passwordTextField) {
        [textField endEditing:YES];
        [self onTouchupInsideLoginButton:self.emailLoginButton];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    return YES;
}

@end
