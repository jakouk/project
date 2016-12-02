//
//  UserInfo.h
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

<<<<<<< HEAD
@property NSString *userEmail;
@property NSString *userPassword;
=======
@property NSString *userId;
@property NSString *userPass;

@property NSString *userToken;

@property NSDictionary *userData;
>>>>>>> 416f96d4022b441d0141ceadbf72a6523d8fe8a5

+ (instancetype)sharedUserInfo;

@end
