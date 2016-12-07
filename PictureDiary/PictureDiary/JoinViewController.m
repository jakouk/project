//
//  JoinViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "JoinViewController.h"

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
    self.emailField.delegate = self;
    self.userNameField.delegate = self;
    self.passwordField.delegate = self;
    self.rePasswordField.delegate = self;
    
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
    
    [self createCancelButton];
    [self createJoinButton];
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
    
    self.userNameField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.475, viewWidth*0.76, viewHeight*0.06)];
    self.userNameField.borderStyle = UITextBorderStyleNone;
    self.userNameField.textColor = [UIColor whiteColor];
    self.userNameField.tag = 0;
    
    self.emailField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.555, viewWidth*0.76, viewHeight*0.06)];
    self.emailField.borderStyle = UITextBorderStyleNone;
    self.emailField.textColor = [UIColor whiteColor];
    self.emailField.tag = 1;
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.635, viewWidth*0.76, viewHeight*0.06)];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.borderStyle = UITextBorderStyleNone;
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.tag = 2;
    
    self.rePasswordField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.715, viewWidth*0.76, viewHeight*0.06)];
    self.rePasswordField.secureTextEntry = YES;
    self.rePasswordField.borderStyle = UITextBorderStyleNone;
    self.rePasswordField.textColor = [UIColor whiteColor];
    self.rePasswordField.tag = 3;
    
    // placeholder custom
    self.emailField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@" 이름"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont boldSystemFontOfSize:15.0f]
                                                 }
     ];
    self.userNameField.attributedPlaceholder =
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
    
}

- (void)createJoinButton {
    
    const CGFloat viewWidth = self.view.frame.size.width;
    const CGFloat viewHeight = self.view.frame.size.height;
    
    self.joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.joinButton setFrame:CGRectMake(viewWidth*0.12, viewHeight*0.81, viewWidth*0.76, viewHeight*0.06)];
    [self.joinButton setTitle:@"회원가입" forState:UIControlStateNormal];
    [self.joinButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.joinButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.joinButton setBackgroundColor: [UIColor orangeColor]];
//    self.joinButton.layer.borderWidth = 2.0f;
//    self.joinButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.joinButton.layer.cornerRadius = 10.0f;
    [self.joinButton addTarget:self
                              action:@selector(onTouchupInsideJoinButton:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.joinButton];
}

- (void)createCancelButton {
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    [self.cancelButton setTitle:@"이미 계정이 있으신가요? 로그인" forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:[UIColor colorWithWhite:1 alpha:0.2]];
    [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self
                        action:@selector(onTouchupInsideCancelButton:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
}


#pragma mark -
#pragma mark Actions

- (void)onTouchupInsideJoinButton:(UIButton *)sender {
    
    [self showErrorAlert];
    
}

- (void)showErrorAlert {
    
}

- (void)onTouchupInsideCancelButton:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, 175) animated:YES];
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
    
    [self.userNameField endEditing:YES];
    [self.emailField endEditing:YES];
    [self.passwordField endEditing:YES];
    [self.rePasswordField endEditing:YES];
}


@end
