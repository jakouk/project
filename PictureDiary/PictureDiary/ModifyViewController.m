//
//  ModifyViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "ModifyViewController.h"

@interface ModifyViewController ()
<UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>

//사진 수정 컬렉션뷰, 텍스트관련 누를 경우 스크롤뷰
@property (strong, nonatomic) IBOutlet UICollectionView *imageCollectionView;
@property (strong, nonatomic) IBOutlet UIScrollView *editScrollView;

//수정될 텍스트 필드, 텍스트뷰
@property (strong, nonatomic) IBOutlet UITextField *modifiedTextField;
@property (strong, nonatomic) IBOutlet UITextView *modifiedTextView;

@property NSArray *modifiedImageList;
@end

@implementation ModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //컬렉션뷰
    [self.imageCollectionView setDelegate:self];
    [self.imageCollectionView setDataSource:self];
    //스크롤뷰
    [self.editScrollView setDelegate:self];
    //텍스트뷰
    [self.modifiedTextView setDelegate:self];
    //텍스트필드
    [self.modifiedTextField setDelegate:self];
    
    self.modifiedImageList =
    @[@"sample1",@"sample2",@"sample3",@"sample4",@"sample5",@"sample6",@"sample7",@"sample8",@"sample9",@"sample10",@"sample11"];

}

#pragma mark - collection count
//컬렉션뷰 세션 갯수
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}

//컬렉션뷰 아이템 갯수
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.modifiedImageList.count;
}

#pragma mark - cell setting
//셀 셋팅
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [self.imageCollectionView dequeueReusableCellWithReuseIdentifier:@"modifiedCell" forIndexPath:indexPath];
    
    //image
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    [imageview setFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageview setImage:[UIImage imageNamed:self.modifiedImageList[indexPath.row]]];
    [cell.contentView addSubview:imageview];
    
    return cell;
}

//셀 크기
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.imageCollectionView.bounds.size.width / 3) - 2.5, self.imageCollectionView.bounds.size.height / 3);
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

#pragma mark - cell action
//셀을 선택했을 경우
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = [UIColor orangeColor].CGColor;
    cell.layer.borderWidth = 3.0f;
    NSLog(@"select");
}

//셀을 다시 선택했을 경우
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    cell.layer.borderColor = nil;
    cell.layer.borderWidth = 0.0f;
    NSLog(@"deselect");
}

#pragma mark - text field
//텍스트필드를 처음눌렀을 경우에 동작하는 메서드
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{   //메인스크롤이 위로 올라감
    [self.editScrollView setContentOffset:CGPointMake(0, 100) animated:YES];
    return YES;
}

//텍스트필드에서 작업을 종료했을 경우에 동작하는 메서드
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{   //메일스크롤이 원래위치로 돌아옴
    [self.editScrollView setContentOffset:CGPointMake(0, - 60) animated:YES];
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
    [self.editScrollView setContentOffset:CGPointMake(0, 180) animated:YES];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self.editScrollView setContentOffset:CGPointMake(0, - 60) animated:YES];
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
