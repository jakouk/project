//
//  UserInfo.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//userToken
@property NSString *userToken;

//Main nextUrl
@property NSString *mainNextUrl;

//Main wordDic
@property NSDictionary *wordDic;


//Search search Data
@property NSDictionary *searchData;

//Search searchNextUrl
@property NSString *searchNextUrl;

//ReadData
@property NSDictionary *readData;

+ (instancetype)sharedUserInfo;

@end
