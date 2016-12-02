//
//  LoginViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "LoginViewController.h"
#import "JoinViewController.h"



@interface LoginViewController () <UITextFieldDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property UIScrollView *scrollView;
@property UITextField *emailTextField;
@property UITextField *passwordTextField;
@property UISwitch *isAutoLoginSwitch;
@property UIButton *emailLoginButton;
@property UIButton *fbLoginButton;
@property UIButton *joinButton;

@end


@implementation LoginViewController


#pragma mark
#pragma mark View Controller Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLayoutSubview];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark
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
    
    UIImageView *titleLogo = [[UIImageView alloc] initWithFrame:CGRectMake(self.scrollView.center.x-45, 100, 90, 90)];
    [titleLogo setImage:[UIImage imageNamed:@"templogo"]];
    [self.scrollView addSubview:titleLogo];
    
}

- (void)createInputTextFields {
    
    const CGFloat viewWidth = self.view.frame.size.width;
    const CGFloat viewHeight = self.view.frame.size.height;
    
    self.emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.525, viewWidth*0.76, viewHeight*0.075)];
    self.emailTextField.borderStyle = UITextBorderStyleNone;
    self.emailTextField.textColor = [UIColor whiteColor];
    self.passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(viewWidth*0.12, viewHeight*0.615, viewWidth*0.76, viewHeight*0.075)];
    self.passwordTextField.borderStyle = UITextBorderStyleNone;
    self.emailTextField.textColor = [UIColor whiteColor];
    
    // placeholder custom
    self.emailTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"E-mail address"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont systemFontOfSize:17.0f]
                                                 }
     ];
    self.passwordTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Password"
                                    attributes:@{
                                                 NSForegroundColorAttributeName: [UIColor whiteColor],
                                                 NSFontAttributeName : [UIFont systemFontOfSize:17.0f]
                                                 }
     ];
    
    // textfield bottom line
    const CGFloat borderWidth = 2;
    CALayer *emailBottomBorder = [CALayer layer];
    emailBottomBorder.borderColor = [UIColor whiteColor].CGColor;
    emailBottomBorder.frame = CGRectMake(0,self.emailTextField.frame.size.height - borderWidth,self.emailTextField.frame.size.width,1);
    emailBottomBorder.borderWidth = borderWidth;
    [self.emailTextField.layer addSublayer:emailBottomBorder];
    [self.scrollView addSubview:self.emailTextField];
    
    CALayer *passwordBottomBorder = [CALayer layer];
    passwordBottomBorder.borderColor = [UIColor whiteColor].CGColor;
    passwordBottomBorder.frame = CGRectMake(0.0f,self.passwordTextField.frame.size.height - borderWidth,self.passwordTextField.frame.size.width,1.0f);
    passwordBottomBorder.borderWidth = borderWidth;
    [self.passwordTextField.layer addSublayer:passwordBottomBorder];
    [self.scrollView addSubview:self.passwordTextField];
    
}

- (void)createLoginButtons {
    
    const CGFloat viewWidth = self.view.frame.size.width;
    const CGFloat viewHeight = self.view.frame.size.height;
    
    self.emailLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.emailLoginButton setFrame:CGRectMake(viewWidth*0.12, viewHeight*0.71, viewWidth*0.76, viewHeight*0.075)];
    [self.emailLoginButton setTitle:@"이메일로 로그인" forState:UIControlStateNormal];
    [self.emailLoginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:15.f]];
    [self.emailLoginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.emailLoginButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.emailLoginButton setBackgroundColor: [UIColor clearColor]];
    self.emailLoginButton.layer.borderWidth = 2.0f;
    self.emailLoginButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.emailLoginButton.layer.cornerRadius = 10.0f;
    [self.scrollView addSubview:self.emailLoginButton];
    
    self.fbLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.fbLoginButton setFrame:CGRectMake(viewWidth*0.12, viewHeight*0.8, viewWidth*0.76, viewHeight*0.075)];
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
    [self.view addSubview:self.joinButton];
    [self.joinButton addTarget:self action:@selector(onTouchupInsideJoinButton:) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark
#pragma mark Keyboard Notification Methods


#pragma mark
#pragma mark Actions


- (void)onTouchupInsideJoinButton:(UIButton *)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    JoinViewController *joinViewController = [storyBoard instantiateViewControllerWithIdentifier:@"JoinViewController"];
    [self.navigationController pushViewController:joinViewController animated:YES];
}


#pragma mark
#pragma mark TextField Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    [textField becomeFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField endEditing:YES];
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    [self performSelector:@selector(blankTapped:) withObject:nil];
    UITapGestureRecognizer *tapScroll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blankTapped:)];
    tapScroll.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapScroll];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField endEditing:YES];
    [textField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointZero animated:YES];
    return YES;
}

- (void)blankTapped:(UIControl *)sender {
    
    [_emailTextField resignFirstResponder];
    [_passwordTextField endEditing:YES];
}





@end
