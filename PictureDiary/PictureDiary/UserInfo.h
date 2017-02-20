//
//  UserInfo.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

#pragma mark - Login, Join
//LoginData
@property NSDictionary *loginData;

//JoinData
@property NSDictionary *joinData;


#pragma mark - userToken
//Outh 2.0 Token number Save
@property NSString *userToken;


#pragma mark - mainData
//First Main Data ( 10 data )
@property NSDictionary *firstMainData;

//if userData > 10 , mainDataURL
@property NSString *mainNextUrl;

//mainAddData 
@property NSDictionary *wordDic;


#pragma mark - searchData
//First search Data
@property NSDictionary *searchData;

//if searchData > 10, searchNextURL
@property NSString *searchNextUrl;

//Certain UserData ( only 1 data )
@property NSDictionary *readData;


#pragma mark - userInformation
//userInfomation
@property NSDictionary *userInfomation;

+ (instancetype)sharedUserInfo;

@end
