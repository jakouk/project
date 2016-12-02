//
//  UserInfo.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+ (instancetype)sharedUserInfo {
<<<<<<< HEAD
    
    static UserInfo *info = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (info == nil) {
            info = [[UserInfo alloc] init];
        }
    });
    return info;
=======
    static UserInfo * instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
>>>>>>> 416f96d4022b441d0141ceadbf72a6523d8fe8a5
}

@end
