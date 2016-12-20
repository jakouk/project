//
//  RequestObject.h
//  PictureDiary
//
//  Created by jakouk on 2016. 12. 3..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UpdateFinishDataBlock)(void);

@interface RequestObject : NSObject

//test just User
+ (void)requestUserData;

//requestJoinData
+ (void)requestJoinData:(NSString *)userId userPass:(NSString *)userPass userName:(NSString *)userName;

//requestLoginData
+ (void)requestLoginData:(NSString *)userId userPass:(NSString *)userPass;

//requestMainData
+ (void)requestMainData;

//requestAddMainCell
+ (void)requestAddMain:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestReadData
+ (void)requestReadData:(NSString *)PostId;

//requestSearch
+ (void)requestSearch:(NSString *)searchData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//reuqestUserInfo
+ (void)requestUserInfo;

//requestLogoutData
+ (void)requestLogoutData;

//requestDeleteData
+ (void)requestDeleteData:(NSString *)deletaData pdateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestWriteData
+ (void)requestWriteData:(NSString *)title cotent:(NSString *)content imageArray:(NSArray *)imageArray updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;


@end
