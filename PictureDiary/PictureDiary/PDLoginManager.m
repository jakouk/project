//
//  PDLoginManger.m
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "PDLoginManager.h"

@implementation PDLoginManager


//requestJoin (POST)
+ (void)requestJoinData:(NSString *)userId userPass:(NSString *)userPass userName:(NSString *)userName userProfile:(UIImage *)userProfile updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSString *requestURL = [[self requestURL:RequestTypeJoin
                                       param:nil
                                    postData:nil] absoluteString];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:userName forKey:ParamNameUserNameKey];
    [bodyParams setObject:userId forKey:ParamNameUserIDKey];
    [bodyParams setObject:userPass forKey:ParamNameUserPassWordKey];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:requestURL
                                                                                             parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                                 
                                                                                                 NSString *imagefileName = [NSString stringWithFormat:@"%@.jpeg",userName];
                                                                                                 NSData *imageData = UIImageJPEGRepresentation(userProfile, 0.1);
                                                                                                 [formData appendPartWithFileData:imageData name:ParamNameUserProfile fileName:imagefileName mimeType:@"image/jpeg"];
                                                                                             }
                                                                                                  error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      //error 처리는 JoinView에서 함.
                      [UserInfo sharedUserInfo].joinData = responseObject;
                      UpdateFinishDataBlock();
                      
                  }];
    [uploadTask resume];
    
}

//requestLogin ( POST )
+(void)requestLoginData:(NSString *)userId userPass:(NSString *)userPass updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSString *requestURL = [[self requestURL:RequestTypeLogin
                                       param:nil
                                    postData:nil]absoluteString];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:userId forKey:ParamNameUserIDKey];
    [bodyParams setObject:userPass forKey:ParamNameUserPassWordKey];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:requestURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                              } error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( error == NULL ) {
            [UserInfo sharedUserInfo].loginData = responseObject;
            UpdateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
    
}

//logout ( GET )
+ (void)requestLogoutData:(UpdateFinishDataBlock)updateFinishDataBlock {
    
    NSURL *url = [self requestURL:RequestTypeLogout
                            param:nil
                         postData:nil];
    NSMutableURLRequest *urlRequest =  [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( responseObject != NULL ) {
            
        } else {
            
            [UserInfo sharedUserInfo].userToken = nil;
            updateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
}

@end
