//
//  PDUserManager.h
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "RequestObject.h"

@interface PDUserManager : RequestObject

//reuqestUserInfo
+ (void)requestUserInfo:(UpdateFinishDataBlock)updateFinishDataBlock;


@end
