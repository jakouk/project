//
//  UserInfo.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject


/***
 Outh 2.0 Token number Save
 Token use X-Authorization
***/
@property NSString *userToken;

/***
 mainData is Maxmum 10
 downScroll mod 7 is zero addReadData;
 ***/
@property NSString *mainNextUrl;

//Main wordDic
@property NSDictionary *wordDic;


//Search search Data
@property NSDictionary *searchData;

//Search searchNextUrl
@property NSString *searchNextUrl;

//ReadData
@property NSDictionary *readData;


//userInfomation
@property NSDictionary *userInfomation;

+ (instancetype)sharedUserInfo;

@end
