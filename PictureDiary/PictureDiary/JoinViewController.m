//
//  JoinViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "JoinViewController.h"
#import "RequestObject.h"
#import "UserInfo.h"

@interface JoinViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UITextField *emailField;
@property (nonatomic) UITextField *userNameField;
@property (nonatomic) UITextField *passwordField;
@property (nonatomic) UITextField *rePasswordField;
@property (nonatomic) UIButton *joinButton;
@property (nonatomic) UIButton *cancelButton;

@end

@implementation JoinViewController


#pragma mark -
#pragma mark View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLayoutSubview];
    
    // 키보드의 움직임 확인하는 노티피케이션
    [self registerForKeyboardNotifications];
    
    // 회원가입시 네트워크와의 통신 가능 여부 확인하는 노티피케이션
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userJoinIn:)
                                                 name:JoinNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    [self unregisterForKeyboardNotifications];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:JoinNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Create Subviews

- (void)createLayoutSubview {
    
    self.scrollView =
    [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.9)];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self createCancelButton];
    [self createJoinButton];
    [self createTitle];
    [self createInputTextFields];
}


- (void)createTitle {
    
    UIImageView *titleLogo =
    [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-30, self.view.frame.size.height*0.25, 60, 60)];
    [titleLogo setImage:[UIImage imageNamed:@"ladder-128"]];
    [self.scrollView addSubview:titleLogo];
    
}


- (void)createInputTextFields {
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.12, self.view.frame.size.height*0.475, self.view.frame.size.width*0.76, self.view.frame.size.height*0.06)];
    self.userNameField.borderStyle = UITextBorderStyleNone;
    self.userNameField.textColor = [UIColor whiteColor];
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.12, self.view.frame.size.height*0.555, self.view.frame.size.width*0.76, self.view.frame.size.height*0.06)];
    self.emailField.borderStyle = UITextBorderStyleNone;
    self.emailField.textColor = [UIColor whiteColor];
    self.emailField.keyboardType = UIKeyboardTypeEmailAddress;
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.12, self.view.frame.size.height*0.635, self.view.frame.size.width*0.76, self.view.frame.size.height*0.06)];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.textColor = [UIColor whiteColor];
    
    self.rePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.12, self.view.frame.size.height*0.715, self.view.frame.size.width*0.76, self.view.frame.size.height*0.06)];
    self.rePasswordField.secureTextEntry = YES;
    self.rePasswordField.borderStyle = UITextBorderStyleNone;
    self.rePasswordField.textColor = [UIColor whiteColor];
 
    
    // placeholder custom
    self.userNameField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@" 아이디"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]
                                                 }
     ];
    self.emailField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@" 이메일(example@gmail.com)"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]
                                                 }
     ];
    self.passwordField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@" 비밀번호"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]
                                                 }
     ];
    self.rePasswordField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@" 비밀번호 확인"
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
    CGRectMake(0,self.emailField.frame.size.height - borderWidth,self.emailField.frame.size.width,1);
    emailBottomBorder.borderWidth = borderWidth;
    [self.emailField.layer addSublayer:emailBottomBorder];
    [self.scrollView addSubview:self.emailField];
    
    CALayer *userNameBottomBorder = [CALayer layer];
    userNameBottomBorder.borderColor = [UIColor whiteColor].CGColor;
    userNameBottomBorder.frame =
    CGRectMake(0.0f,self.userNameField.frame.size.height - borderWidth,self.userNameField.frame.size.width,1.0f);
    userNameBottomBorder.borderWidth = borderWidth;
    [self.userNameField.layer addSublayer:userNameBottomBorder];
    [self.scrollView addSubview:self.userNameField];
    
    CALayer *passwordBottomBorder = [CALayer layer];
    passwordBottomBorder.borderColor = [UIColor whiteColor].CGColor;
    passwordBottomBorder.frame =
    CGRectMake(0.0f,self.passwordField.frame.size.height - borderWidth,self.passwordField.frame.size.width,1.0f);
    passwordBottomBorder.borderWidth = borderWidth;
    [self.passwordField.layer addSublayer:passwordBottomBorder];
    [self.scrollView addSubview:self.passwordField];
    
    CALayer *rePasswordBottomBorder = [CALayer layer];
    rePasswordBottomBorder.borderColor = [UIColor whiteColor].CGColor;
    rePasswordBottomBorder.frame =
    CGRectMake(0.0f,self.rePasswordField.frame.size.height - borderWidth,self.rePasswordField.frame.size.width,1.0f);
    rePasswordBottomBorder.borderWidth = borderWidth;
    [self.rePasswordField.layer addSublayer:rePasswordBottomBorder];
    [self.scrollView addSubview:self.rePasswordField];
    
    self.emailField.delegate = self;
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    self.rePasswordField.delegate = self;
}


- (void)createJoinButton {
    
    self.joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.joinButton setFrame:CGRectMake(self.view.frame.size.width*0.12, self.view.frame.size.height*0.81, self.view.frame.size.width*0.76, self.view.frame.size.height*0.06)];
    [self.joinButton setTitle:@"회원가입" forState:UIControlStateNormal];
    [self.joinButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    self.joinButton.layer.borderWidth = 2.0f;
    self.joinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.joinButton.layer.cornerRadius = 10.0f;
    [self.joinButton addTarget:self
                        action:@selector(onTouchupInsideJoinButton:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.joinButton];
}


- (void)createCancelButton {
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.93, self.view.frame.size.width, self.view.frame.size.height*0.07)];
    [self.cancelButton setTitle:@"계정이 있으신가요?  로그인" forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.1f]];
    [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self
                          action:@selector(onTouchupInsideCancelButton:)
                forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
}



#pragma mark -
#pragma mark Actions


// 회원가입 버튼 클릭시
- (void)onTouchupInsideJoinButton:(UIButton *)sender {
    
    NSString *userName = [NSString stringWithFormat:@"%@",self.userNameField.text];
    NSString *email = [NSString stringWithFormat:@"%@",self.emailField.text];
    NSString *password = [NSString stringWithFormat:@"%@",self.passwordField.text];
    NSString *rePassword = [NSString stringWithFormat:@"%@",self.rePasswordField.text];
    
    UIAlertController *alert;
    UIAlertAction *action;
    
    // 텍스트필드 입력 내용 체크
    if (userName.length == 0 || [userName containsString:@" "]) {
        
        // 이름 미입력
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"이름을 입력하세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    } else if (email.length == 0 || [email containsString:@" "]) {
        
        // 이메일 미입력
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"이메일을 입력하세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([self checkEmail:email] == NO) {
        
        // 이메일 형식 체크
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"정확한 이메일을 입력하세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    } else if (password.length == 0 || [password containsString:@" "]) {
        
        // 비밀번호 미입력
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"비밀번호를 입력하세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (rePassword.length == 0 || [rePassword containsString:@" "]) {
        
        // 비밀번호 확인 미입력
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"비밀번호를 다시 한 번 입력하세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if (![password isEqualToString:rePassword]) {
        
        // 비밀번호 미일치
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"입력한 비밀번호가 서로 일치하지 않습니다."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
       
        [RequestObject requestJoinData:email userPass:password userName:userName];
        
    }
}


// 회원가입시 네트워크 구현
- (void)userJoinIn:(NSNotification *)noti {
    
    UIAlertController *alert;
    UIAlertAction *action;
    NSDictionary *dic = noti.userInfo;
    
    if (dic == nil) {
        
        // 네트워크가 연결되지 않은 경우
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"사용중인 네트워크 상태를 확인해 주세요."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];

    } else if ([dic objectForKey:@"username"] != nil && [dic objectForKey:@"password"] == nil) {
        
        // 이름 가입 여부 체크
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"이름이 이미 등록되어 있습니다."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([dic objectForKey:@"email"] != nil && [dic objectForKey:@"password"] == nil) {
        
        // 이메일 가입 여부 체크
        alert = [UIAlertController alertControllerWithTitle:@"알림"
                                                    message:@"이메일이 이미 등록되어 있습니다."
                                             preferredStyle:UIAlertControllerStyleAlert];
        action = [UIAlertAction actionWithTitle:@"확인" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else if ([dic objectForKey:@"password"] != nil) {
        
        // 회원 정보 서버 저장 메소드
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"알림"
                                            message:@"회원가입이 완료되었습니다. 로그인 하세요."
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action =
        [UIAlertAction actionWithTitle:@"확인"
                                 style:UIAlertActionStyleDefault
                               handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
}


- (void)onTouchupInsideCancelButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)blankTapped:(UIControl *)sender {
    
    [self.userNameField endEditing:YES];
    [self.emailField endEditing:YES];
    [self.passwordField endEditing:YES];
    [self.rePasswordField endEditing:YES];
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

// 글자 수 제한
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//
//    NSInteger minLength = 6;
//    if (string && [string length] && textField.text.length <= minLength) {
//        return NO;
//    }
//    return YES;
//}



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
        [self.scrollView setContentOffset:CGPointMake(0, 140) animated:YES];
        
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
    
    if (textField == self.userNameField) {
        [textField endEditing:YES];
        [self.emailField becomeFirstResponder];
    } else if (textField == self.emailField) {
        [textField endEditing:YES];
        [self.passwordField becomeFirstResponder];
    } else if (textField == self.passwordField) {
        [textField endEditing:YES];
        [self.rePasswordField becomeFirstResponder];
    } else if (textField == self.rePasswordField) {
        [textField endEditing:YES];
        [self onTouchupInsideJoinButton:self.joinButton];
        [self.scrollView setContentOffset:CGPointZero animated:YES];
    }
    return YES;
}

@end
