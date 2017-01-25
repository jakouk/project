//
//  PDLoginManger.h
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "RequestObject.h"
@class UIImage;

@interface PDLoginManager : RequestObject

//requestJoinData
+ (void)requestJoinData:(NSString *)userId userPass:(NSString *)userPass userName:(NSString *)userName userProfile:(UIImage *)userProfile updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestLoginData
+ (void)requestLoginData:(NSString *)userId userPass:(NSString *)userPass updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestLogoutData
+ (void)requestLogoutData:(UpdateFinishDataBlock)updateFinishDataBlock;



@end
