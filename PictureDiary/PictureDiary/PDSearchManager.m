//
//  PDSearchManager.m
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "PDSearchManager.h"

@implementation PDSearchManager


//requestSearch ( GET )
+ (void)requestSearch:(NSString *)searchData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSMutableDictionary *urlParam = [[NSMutableDictionary alloc] init];
    [urlParam setObject:searchData forKey:ParamNamePostTitle];
    
    NSString *urlStr = [[self requestURL:RequestTypeSearchData param:urlParam postData:nil] absoluteString];
    
    //All Language Encoding
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL * url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *urlRequest =  [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
        } else {
            
            [UserInfo sharedUserInfo].searchData = responseObject;
            UpdateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
    
}

//add Search
+(void)reqeustAddSearch:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSURL * url = [NSURL URLWithString:nextUrl];
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( error == NULL ) {
            
            [UserInfo sharedUserInfo].searchData = responseObject;
            UpdateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
    
}


@end
