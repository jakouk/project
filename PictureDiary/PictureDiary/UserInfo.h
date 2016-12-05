//
//  UserInfo.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property NSString *userEmail;
@property NSString *userPassword;
@property NSString *userId;
@property NSString *userPass;

@property NSString *userToken;

@property NSDictionary *userData;

+ (instancetype)sharedUserInfo;

@end
