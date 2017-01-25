//
//  RequestObject.h
//  PictureDiary
//
//  Created by jakouk on 2016. 12. 3..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeLogin,
    RequestTypeJoin,
    RequestTypeMainData,
    RequestTypeReadData,
    RequestTypeSearchData,
    RequestTypeWrite,
    RequestTypeLogout,
    RequestTypeUserInfo,
    RequestTypeReadModify,
    RequestTypeDelete
};

@interface RequestObject : NSObject

typedef void(^UpdateFinishDataBlock)(void);

//POSTtype make method
+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic postData:(NSString *)PostData;

//reqeustMehotd
+ (NSMutableURLRequest *)requestURL:(NSURL *)url httpMethod:(NSString *)httpMethod;

//Add Token
+ (void)urlRequestToken:(NSMutableURLRequest *)urlRequest;


@end
