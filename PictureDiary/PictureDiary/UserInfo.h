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

//Search search Data
@property NSDictionary *searchData;

//Main nextUrl
@property NSString *nextUrl;

//Main wordDic
@property NSDictionary *wordDic;

+ (instancetype)sharedUserInfo;

@end
