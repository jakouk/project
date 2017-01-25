//
//  PDMainManager.m
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "PDMainManager.h"

@implementation PDMainManager

#pragma mark - requestMain
//requestMain ( GET )
+ (void)requestMainDataUpdateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock; {
    
    NSURL * url = [self requestURL:RequestTypeMainData
                             param:nil
                          postData:nil];
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( error == NULL ) {
            
            [UserInfo sharedUserInfo].firstMainData = responseObject;
            UpdateFinishDataBlock();
            
        }
        
    }];
    
    [dataTask resume];
}

//requestAddMain ( GET )
+ (void)requestAddMain:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSURL * url = [NSURL URLWithString:nextUrl];
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( error == NULL ) {
            
            [UserInfo sharedUserInfo].wordDic = responseObject;
            UpdateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
    
}


@end
