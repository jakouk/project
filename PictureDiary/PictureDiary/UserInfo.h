//
//  UserInfo.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


//LoginData
@property NSDictionary *loginData;

//Outh 2.0 Token number Save
@property NSString *userToken;


//First Main Data ( 10 data )
@property NSDictionary *firstMainData;

//if userData > 10 , mainDataURL
@property NSString *mainNextUrl;

//mainAddData 
@property NSDictionary *wordDic;


//First search Data
@property NSDictionary *searchData;

//if searchData > 10, searchNextURL
@property NSString *searchNextUrl;

//Certain UserData ( only 1 data )
@property NSDictionary *readData;



//userInfomation
@property NSDictionary *userInfomation;

+ (instancetype)sharedUserInfo;

@end
