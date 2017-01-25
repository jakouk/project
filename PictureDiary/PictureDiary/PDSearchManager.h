//
//  PDSearchManager.h
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "RequestObject.h"

@interface PDSearchManager : RequestObject

//requestSearch
+ (void)requestSearch:(NSString *)searchData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

//requestSearchAddData
+(void)reqeustAddSearch:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock;

@end
