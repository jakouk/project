//
//  ModifyViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "ModifyViewController.h"
#import <UIImageView+WebCache.h>

@interface ModifyViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

//imageCollectionView
@property (weak, nonatomic) IBOutlet UICollectionView *imageCollection;

//title
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;

//content
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

//keyboardUpdown Check
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyBoardView;

@property NSString *postId;

@property NSMutableArray *modifiedImageList;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageCollection.dataSource = self;
    self.imageCollection.delegate = self;
    
    // imageList
    self.modifiedImageList = [[NSMutableArray alloc] init];
    
    //title, content, image
    [self.modifiedImageList addObjectsFromArray:[[UserInfo sharedUserInfo].readData objectForKey:@"photos"]];
    
    NSLog(@"readData photos count = %@",[[UserInfo sharedUserInfo].readData objectForKey:@"photos"]);
    
    NSLog(@"self.modifiedImageList.count = %ld",self.modifiedImageList.count);
    
    self.titleTextField.text = [[UserInfo sharedUserInfo].readData objectForKey:@"title"];
    self.contentTextView.text = [[UserInfo sharedUserInfo].readData objectForKey:@"content"];
    
    NSNumber *postNumber = [[NSNumber alloc] init];
    postNumber = [[UserInfo sharedUserInfo].readData objectForKey:@"id"];
    self.postId = [[NSString alloc] initWithString:[postNumber stringValue]];
    
    //collectionView reload
    //[self collectionViewReload];
    
    //keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAnimate:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}

- (void)collectionViewReload {
    [self.imageCollection reloadData];
}

#pragma mark - collection count
//컬렉션뷰 세션 갯수
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//collectionView cell number
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSLog(@"self.modifiedImageList.count = %ld",self.modifiedImageList.count);
    return self.modifiedImageList.count;
}

#pragma mark - cell setting
//셀 셋팅
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *photos  = [self.modifiedImageList objectAtIndex:indexPath.row];
    NSDictionary *image = [photos objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:[image objectForKey:@"full_size"]];
    
    UIImageView *fullSizeImage = [[UIImageView alloc] init];
    fullSizeImage.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    
    [fullSizeImage sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"home"]];
    [fullSizeImage setContentMode:UIViewContentModeScaleToFill];
    [cell.contentView addSubview:fullSizeImage];
    
    NSLog(@"hello");
    
    return cell;
}

//셀 크기
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.imageCollection.frame.size.height, self.imageCollection.frame.size.height);
}

//컬렉션과 컬렉션 width 간격, 내부여백
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//셀간의 최소간격
//위아래 간격 hight
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

#pragma mark - text field
//텍스트필드를 처음눌렀을 경우에 동작하는 메서드
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{   //메인스크롤이 위로 올라감
    return YES;
}

//텍스트필드에서 작업을 종료했을 경우에 동작하는 메서드
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{   //메일스크롤이 원래위치로 돌아옴
    return YES;
}

//키보드의 리턴버튼을 눌렀을 경우 동작하는 메서드
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES]; //키보드해제
    return YES;
}

#pragma mark - text view
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //newLineCharacterSet이 있으면 done button이 호출됨. 따라서 키보드가 사라짐.
    NSCharacterSet *doneButtonCharacterSet = [NSCharacterSet newlineCharacterSet];
    NSRange replacementTextRange = [text rangeOfCharacterFromSet:doneButtonCharacterSet];
    NSUInteger location = replacementTextRange.location;
    
    //텍스트가 140자가 넘지 않도록 제한
    if (textView.text.length + text.length > 140){
        if (location != NSNotFound){
            [textView resignFirstResponder];
        }
        return NO;
    }
    
    else if (location != NSNotFound){
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//checkBtn Click
- (IBAction)touchupInsideEditingFinishButton:(UIButton *)sender {
    
    [RequestObject requestModifyData:self.titleTextField.text content:self.contentTextView.text postId:self.postId updateFinishDataBlok:^{
        [self readViewUpdateMethod];
    }];
}

//readViewUpdate
- (void)readViewUpdateMethod {
    NSLog(@"??");
    [RequestObject requestReadData:self.postId];
    [self.navigationController popViewControllerAnimated:YES];
}


//keyboard up
- (void)keyboardWillAnimate:(NSNotification *)notification {
    
    CGRect keyboardBounds;
     [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    if([notification name] == UIKeyboardWillShowNotification)
    {
        self.keyBoardView.constant = keyboardBounds.size.height;
    }
    else if([notification name] == UIKeyboardWillHideNotification)
    {
        self.keyBoardView.constant = 0;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)tapGestureMethod:(UITapGestureRecognizer *)sender {
    
    [self.titleTextField resignFirstResponder];
    [self.contentTextView resignFirstResponder];
    
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
