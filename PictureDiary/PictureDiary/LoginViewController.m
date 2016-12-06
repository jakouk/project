//
//  LoginViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "LoginViewController.h"
#import "JoinViewController.h"
#import "MainViewController.h"
#import "UserInfo.h"

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
    self.emailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Create Subviews

- (void)createLayoutSubview {
    
    const CGFloat viewWidth = self.view.frame.size.width;
    const CGFloat viewHeight = self.view.frame.size.height;
    
    // scrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight*0.9)];
    
    // scrollView content size
    [self.scrollView setContentSize:CGSizeMake(viewWidth, viewHeight)];
    
    // scrollView delegate
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];
    
    [self createJoinButton];
    [self createLoginButtons];
    [self createTitle];
    [self createInputTextFields];
}

- (void)createTitle {
    
    UIImageView *titleLogo = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x-45, self.view.frame.size.height*0.225, 90, 90)];
    [titleLogo setImage:[UIImage imageNamed:@"templogo"]];
    [self.scrollView addSubview:titleLogo];
    
}

- (void)createInputTextFields {
    
    const CGFloat viewWidth = self.view.frame.size.width;
    const CGFloat viewHeight = self.view.frame.size.height;
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.525, viewWidth*0.76, viewHeight*0.06)];
    self.emailTextField.borderStyle = UITextBorderStyleNone;
    self.emailTextField.textColor = [UIColor whiteColor];
    
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.615, viewWidth*0.76, viewHeight*0.06)];
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
    CGRectMake(0.0f,self.passwordTextField.frame.size.height - borderWidth,self.passwordTextField.frame.size.width,1.0f);
    passwordBottomBorder.borderWidth = borderWidth;
    [self.passwordTextField.layer addSublayer:passwordBottomBorder];
    [self.scrollView addSubview:self.passwordTextField];
    
}

- (void)createLoginButtons {
    
    const CGFloat viewWidth = self.view.frame.size.width;
    const CGFloat viewHeight = self.view.frame.size.height;
    
    self.emailLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emailLoginButton setFrame:CGRectMake(viewWidth*0.12, viewHeight*0.72, viewWidth*0.76, viewHeight*0.06)];
    [self.emailLoginButton setTitle:@"이메일로 로그인" forState:UIControlStateNormal];
    [self.emailLoginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.emailLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.emailLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.emailLoginButton setBackgroundColor: [UIColor orangeColor]];
//    self.emailLoginButton.layer.borderWidth = 2.0f;
//    self.emailLoginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.emailLoginButton.layer.cornerRadius = 10.0f;
    [self.emailLoginButton addTarget:self
                              action:@selector(onTouchupInsideLoginButton:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.emailLoginButton];
    
    self.fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbLoginButton setFrame:CGRectMake(viewWidth*0.12, viewHeight*0.81, viewWidth*0.76, viewHeight*0.06)];
//    [self.fbLoginButton setImage:[UIImage imageNamed:@"fb-art"] forState:UIControlStateNormal];
//    [self.fbLoginButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.fbLoginButton setTitle:@"페이스북으로 로그인" forState:UIControlStateNormal];
    [self.fbLoginButton.titleLabel setFont:[UIFont systemFontOfSize:15.f]];
    [self.fbLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fbLoginButton setBackgroundColor: [UIColor colorWithRed:59.0f/255.f green:89.0f/255.f blue:152.0f/255.f alpha:1.0f]];
    self.fbLoginButton.layer.cornerRadius = 10.0f;
    [self.scrollView addSubview:self.fbLoginButton];
}

- (void)createJoinButton {
    
    self.joinButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.joinButton setTitle:@"첫 방문 이신가요? 회원가입" forState:UIControlStateNormal];
    [self.joinButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
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
    
    NSString *emailString = [NSString stringWithFormat:@"%@",self.emailTextField.text];
    NSString *passwordString = [NSString stringWithFormat:@"%@",self.passwordTextField.text];
    

}

- (void)showErrorAlert {
   
}

- (void)onTouchupInsideJoinButton:(UIButton *)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JoinViewController *joinViewController = [storyboard instantiateViewControllerWithIdentifier:@"JoinViewController"];
    [self presentViewController:joinViewController animated:YES completion:nil];
   
}


#pragma mark -
#pragma mark Validation

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
#pragma mark TextField Delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, 125) animated:YES];
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(blankTapped:)];
    tapScroll.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapScroll];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    return YES;
}

- (void)blankTapped:(UIControl *)sender {
    [self.emailTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

@end
