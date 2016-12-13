//
//  RequestObject.h
//  PictureDiary
//
//  Created by jakouk on 2016. 12. 3..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestObject : NSObject


+ (void)requestUserData;

+ (void)requestJoinData:(NSString *)userId userPass:(NSString *)userPass userName:(NSString *)userName;

+ (void)requestLoginData:(NSString *)userId userPass:(NSString *)userPass;

+ (void)requestMainData;

+ (void)requestReadData:(NSString *)PostId;

+ (void)requestSearch:(NSString *)searchData;

+ (void)requestUserInfo;
@end
