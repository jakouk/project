//
//  PDPageManager.h
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "RequestObject.h"

@interface PDPageManager : RequestObject

//requestReadData
+ (void)requestReadData:(NSString *)PostId updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestDeleteData
+ (void)requestDeleteData:(NSString *)deletaData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestWriteData
+ (void)requestWriteData:(NSString *)title cotent:(NSString *)content imageArray:(NSArray *)imageArray updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestModifyData
+ (void)requestModifyData:(NSString *)title content:(NSString *)content postId:(NSString *)postId updateFinishDataBlok:(UpdateFinishDataBlock)UpdateFinishDataBlock;


@end
