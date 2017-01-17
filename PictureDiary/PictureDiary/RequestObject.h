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
+ (void)requestLoginData:(NSString *)userId userPass:(NSString *)userPass updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;


//requestMainData
+ (void)requestMainDataUpdateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestAddMainCell
+ (void)requestAddMain:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;


//requestReadData
+ (void)requestReadData:(NSString *)PostId updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;


//requestSearch
+ (void)requestSearch:(NSString *)searchData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestSearchAddData
+(void)reqeustAddSearch:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//reuqestUserInfo
+ (void)requestUserInfo:(UpdateFinishDataBlock)updateFinishDataBlock;

//requestLogoutData
+ (void)requestLogoutData:(UpdateFinishDataBlock)updateFinishDataBlock;

//requestDeleteData
+ (void)requestDeleteData:(NSString *)deletaData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestWriteData
+ (void)requestWriteData:(NSString *)title cotent:(NSString *)content imageArray:(NSArray *)imageArray updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestModifyData
+ (void)requestModifyData:(NSString *)title content:(NSString *)content postId:(NSString *)postId updateFinishDataBlok:(UpdateFinishDataBlock)UpdateFinishDataBlock;

@end
