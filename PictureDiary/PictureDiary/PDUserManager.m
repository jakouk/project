//
//  PDUserManager.m
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "PDUserManager.h"

@implementation PDUserManager

//UserInfo Data ( GET )
+ (void)requestUserInfo:(UpdateFinishDataBlock)updateFinishDataBlock{
    
    NSURL * url = [self requestURL:RequestTypeUserInfo
                             param:nil
                          postData:nil];
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        [UserInfo sharedUserInfo].userInfomation = responseObject;
        updateFinishDataBlock();
        
    }];
    
    [dataTask resume];
    
}

//faceBook Login
+ (void)requestFaceBook {
    
}


@end
