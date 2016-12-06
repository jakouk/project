//
//  UserInfo.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "UserInfo.h"

static NSString *userEmailKey = @"userEmail";
static NSString *userPasswordKey = @"userPassword";
static NSString *saveUserLoginKey = @"saveUserLogin";

@implementation UserInfo

+ (instancetype)sharedUserInfo {
    static UserInfo * instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

//아이디, 패스워드 저장
- (void)saveUserEmail:(NSString *)email userPassword:(NSString *)password {

    [[NSUserDefaults standardUserDefaults] setObject:email forKey:userEmailKey];
    [[NSUserDefaults standardUserDefaults] setObject:password forKey:userPasswordKey];
}

// 로그인 상태 저장
- (void)saveLoginState:(BOOL)loginState {
    NSNumber *userLogin = [NSNumber numberWithBool:loginState];
    [[NSUserDefaults standardUserDefaults] setObject:userLogin forKey:saveUserLoginKey];
}

@end
