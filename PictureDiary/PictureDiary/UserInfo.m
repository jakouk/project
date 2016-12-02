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
    static UserInfo * instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

@end
