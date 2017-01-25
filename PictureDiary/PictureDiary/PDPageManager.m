//
//  PDPageManager.m
//  PictureDiary
//
//  Created by jakouk on 2017. 1. 25..
//  Copyright © 2017년 jakouk. All rights reserved.
//

#import "PDPageManager.h"

@implementation PDPageManager


//requestRead ( GET )
+ (void)requestReadData:(NSString *)PostId updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSURL * url = [self requestURL:RequestTypeReadData
                             param:nil
                          postData:PostId];
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( error == NULL) {
            
            [UserInfo sharedUserInfo].readData = responseObject;
            UpdateFinishDataBlock();
        }
    }];
    [dataTask resume];
    
}

#pragma mark -requestDelete
//requestDelete ( DELETE )
+ (void)requestDeleteData:(NSString *)deletaData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSURL * url = [self requestURL:RequestTypeDelete
                             param:nil
                          postData:deletaData];
    NSMutableURLRequest *urlRequest =  [self requestURL:url httpMethod:@"DELETE"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( error == NULL ) {
            UpdateFinishDataBlock();
        }
    }];
    [dataTask resume];
}


#pragma mark -requestWrite
//requestWrite ( POST )
+ (void)requestWriteData:(NSString *)title cotent:(NSString *)content imageArray:(NSArray *)imageArray updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSString *requestURL = [[self requestURL:RequestTypeWrite
                                       param:nil
                                    postData:nil] absoluteString];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:title forKey:ParamNamePostTitle];
    [bodyParams setObject:content forKey:ParamNamePostContent];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:requestURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                                  
                                                                                                  for ( NSDictionary *imageData in imageArray) {
                                                                                                      
                                                                                                      UIImage *image = [imageData objectForKey:@"image"];
                                                                                                      NSNumber *number = [imageData objectForKey:@"imageNumber"];
                                                                                                      NSLog(@"imageNumber : %ld",number.integerValue);
                                                                                                      NSString *imagefileName = [NSString stringWithFormat:@"%@%ld.jpeg",title,number.integerValue];
                                                                                                      
                                                                                                      NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
                                                                                                      [formData appendPartWithFileData:imageData name:@"image" fileName:imagefileName mimeType:@"image/jpeg"];
                                                                                                      
                                                                                                  }
                                                                                              } error:nil];
    
    [self urlRequestToken:request];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"uploading... %lf %% completed",uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      NSLog(@"\n\n response : %@ \n\n",response);
                      NSLog(@"\n\n responseObject : %@ \n\n",responseObject);
                      NSLog(@"\n\n error : %@ \n\n",error);
                      
                      if (error == NULL) {
                          UpdateFinishDataBlock();
                      }
                  }];
    
    [uploadTask resume];
    
}



#pragma mark -requstModify
//requestModify ( PUT )
+ (void)requestModifyData:(NSString *)title content:(NSString *)content postId:(NSString *)postId updateFinishDataBlok:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    
    
    NSString *requestURL = [[self requestURL:RequestTypeReadModify
                                       param:nil
                                    postData:postId] absoluteString];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    [bodyParams setObject:title forKey:ParamNamePostTitle];
    [bodyParams setObject:content forKey:ParamNamePostContent];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"PUT"
                                    
                                                                                              URLString:requestURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                              } error:nil];
    
    [self urlRequestToken:request];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;
    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      dispatch_async(dispatch_get_main_queue(), ^{
                          NSLog(@"uploading... %lf %% completed",uploadProgress.fractionCompleted);
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      
                      if (error == NULL) {
                          UpdateFinishDataBlock();
                      }
                  }];
    
    [uploadTask resume];
}


@end
