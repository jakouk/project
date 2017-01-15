//
//  UserInfo.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "UserInfo.h"


@implementation UserInfo

//singleTone
+ (instancetype)sharedUserInfo {
    
    static UserInfo *info = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (info == nil) {
            info = [[UserInfo alloc] init];
        }
    });
    return info;
}


@end
