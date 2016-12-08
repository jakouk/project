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
+ (BOOL)requestJoinData:(NSString *)userId userPass:(NSString *)userPass userName:(NSString *)userName;
+(BOOL)requestLoginData:(NSString *)userId userPass:(NSString *)userPass;
+ (BOOL)requestMainData;
@end
