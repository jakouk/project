//
//  PDMainManager.h
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "RequestObject.h"

@interface PDMainManager : RequestObject

//requestMainData
+ (void)requestMainDataUpdateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestAddMainCell
+ (void)requestAddMain:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;


@end
