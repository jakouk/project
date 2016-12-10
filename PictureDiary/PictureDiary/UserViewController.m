//
//  UserViewController.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()
<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *userTableView;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.userTableView setDelegate:self];
    [self.userTableView setDataSource:self];
    
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.userTableView.frame.size.width,
                                                                        self.userTableView.frame.size.height)];
    [footerview setBackgroundColor:[UIColor clearColor]];
    [self.userTableView setTableFooterView:footerview];
    
}

#pragma mark - tableview setting
//session
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//row
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if (indexPath.row == 0) {
            [cell.imageView setImage:[UIImage imageNamed:@"usericon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            [cell.textLabel setText:@"사용자 이름"];
            [cell.detailTextLabel setText:@"김건희"];
        }
        
        if (indexPath.row == 1) {
            [cell.imageView setImage:[UIImage imageNamed:@"Emailicon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            [cell.textLabel setText:@"사다리 계정"];
            [cell.detailTextLabel setText:@"cptcpt123@gmail.com"];
        }
        
        if (indexPath.row == 2) {
            [cell.imageView setImage:[UIImage imageNamed:@"Facebookicon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            [cell.textLabel setText:@"페북 계정"];
            [cell.detailTextLabel setText:@"연동"];
        }
        
        if (indexPath.row == 3) {
            [cell.imageView setImage:[UIImage imageNamed:@"Phoneicon"]];
            [cell.imageView setContentMode:UIViewContentModeScaleToFill];
            [cell.textLabel setText:@"연락처"];
            [cell.detailTextLabel setText:@"010 - 1234 - 5678"];
        }
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

#pragma mark - memory
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
