//
//  RequestObject.m
//  PictureDiary
//
//  Created by jakouk on 2016. 12. 3..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "RequestObject.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeLogin,
    RequestTypeJoin,
    RequestTypeMainData,
    RequestTypeSearchData
};

static NSString *const baseURLString = @"http://www.anyfut.com/member/create/";

static NSString *ParamNameUserIDKey = @"email";
static NSString *ParamNameUserNameKey = @"username";
static NSString *ParamNameUserPassWordKey = @"password";
static NSString *ParamNameUserJoinDate = @"date_joined";
static NSString *ParamNameUserPrimaryKey = @"pk";
static NSString *ParamNameUserKeyKey = @"key";

static NSString *JSONSuccessValue = @"success";

@implementation RequestObject

//POSTtype make method
+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic {
    
    NSMutableString *urlString = [baseURLString mutableCopy];
    
    switch (type) {
        case RequestTypeJoin:
            break;
        case RequestTypeLogin:
            break;
        default:
            return nil;
            break;
    }
    
    if ([paramDic count]) {
        NSMutableString *paramString = [NSMutableString stringWithFormat:@"?"];
        
        for (NSString *key in paramDic) {
            [paramString appendString:key];
            [paramString appendString:@"="];
            
            id value = paramDic[key];
            
            if ([value isKindOfClass:[NSString class]]) {
                [paramString appendString:value];
            } else {
                value = [NSString stringWithFormat:@"%@", value];
                [paramString appendString:value];
            }
            [paramString appendString:@"&"];
        }
        [urlString appendString:paramString];
    }
    return [NSURL URLWithString:urlString];
}

//ServerCheck (get)
+ (void)requestUserData {
    
    //기존
    NSURL *requestURL = [NSURL URLWithString:baseURLString];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = requestURL;
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSLog(@"%@", response);
        NSLog(@"%@", error);
        
        NSArray *data = responseObject;
        
        for(NSDictionary *dic in data){
            NSLog(@"%@",dic);
        }
        
    }];
    
    [dataTask resume];
    
}

//requestJoin (POST)
+ (void)requestJoinData:(NSString *)userId userPass:(NSString *)userPass userName:(NSString *)userName  {
    
    
    NSString *requestURL = [[self requestURL:RequestTypeJoin param:nil] absoluteString];
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    
    [bodyParams setObject:userName forKey:ParamNameUserNameKey];
    [bodyParams setObject:userId forKey:ParamNameUserIDKey];
    [bodyParams setObject:userPass forKey:ParamNameUserPassWordKey];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:requestURL
                                                                                             parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) { } error:nil];
    
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
                      
                      NSDictionary *dic = responseObject;
                      NSString *notificationName = JoinNotification;
                      
                      //main deque
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                          [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                              object:nil userInfo:dic];
                          
                      });
                  }];
    
    [uploadTask resume];
    
}

//requestLogin ( POST )
+(void)requestLoginData:(NSString *)userId userPass:(NSString *)userPass {
    
    NSString *requestURL = @"http://www.anyfut.com/member/login/";
    //NSString *requestURL = @"http://192.168.0.153:8000/member/login/";
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    
    [bodyParams setObject:userId forKey:ParamNameUserIDKey];
    [bodyParams setObject:userPass forKey:ParamNameUserPassWordKey];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:requestURL parameters:bodyParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                              } error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSDictionary *dic = responseObject;
        
        NSString *notificationName = LoginNotification;
        
        
        //main deque
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil userInfo:dic];
            
        });
        
    }];
    
    
    [dataTask resume];
    
}

#pragma mark - requestMain
//requestMain ( get )
+ (void)requestMainData {
    
    NSString *urlStr = @"http://www.anyfut.com/post/";
    //NSString *urlStr = @"http://192.168.0.153:8000/post/";
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
    NSLog(@"RequestObject main allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSString *notificationName = MainNotification;
        
        NSMutableDictionary *wordDic = [[NSMutableDictionary alloc] init];
        wordDic = responseObject;
        
        NSLog(@"\n\n responseObject : %@ \n\n",responseObject);
        NSLog(@"\n\n response : %@ \n\n",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil userInfo:wordDic];
            
        });
        
    }];
    
    [dataTask resume];
}

//requestAddMain
+ (void)requestAddMain:(NSString *)nextUrl updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSString *urlStr = nextUrl;
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
    NSLog(@"RequestObject main allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if ( error == NULL ) {
            
            NSLog(@"\n\n responseObject : %@ \n\n",responseObject);
            NSLog(@"\n\n response : %@ \n\n",response);
            
            [UserInfo sharedUserInfo].wordDic = responseObject;
            NSLog(@"mainAdd");
            UpdateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
    
}

//requestRead
+ (void)requestReadData:(NSString *)PostId {
    
    NSString *urlStr = @"http://www.anyfut.com/post/";
    
    NSMutableString *urlString = [NSMutableString stringWithString:urlStr];
    [urlString appendString:PostId];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
    NSLog(@"RequestObject main allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSString *notificationName = ReadNotification;
        
        NSMutableDictionary *wordDic = [[NSMutableDictionary alloc] init];
        wordDic = responseObject;
        
        NSLog(@"\n\n response : %@ \n\n",response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil userInfo:wordDic];
            
        });
        
        
    }];
    [dataTask resume];

}

//requestDelete
#pragma mark -requestDelete
+ (void)requestDeleteData:(NSString *)deletaData pdateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSString *urlStr = @"http://www.anyfut.com/post/";
    
    NSMutableString *urlString = [NSMutableString stringWithString:urlStr];
    [urlString appendString:deletaData];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"DELETE"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
    NSLog(@"RequestObject main allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
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
//requestWrite
+ (void)requestWriteData:(NSString *)title cotent:(NSString *)content imageArray:(NSArray *)imageArray updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSString *requestURL = @"http://www.anyfut.com/post/";
    
    NSMutableDictionary *bodyParams = [[NSMutableDictionary alloc] init];
    
    [bodyParams setObject:title forKey:@"title"];
    [bodyParams setObject:content forKey:@"content"];
    
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
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [request setValue:token forHTTPHeaderField:@"X-Authorization"];
    
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
                      
                      UpdateFinishDataBlock();
                      
                  }];
    
    [uploadTask resume];
    
}



#pragma mark -requstModify
//requestModify
+ (void)requestModifyData {
    
}


//requestSearch
+ (void)requestSearch:(NSString *)searchData updateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.anyfut.com/post/search?title=%@",searchData];
    //NSString *urlStr = [NSString stringWithFormat:@"http://192.168.0.153:8000/post/search?title=%@",searchData];
    
    NSString *urlString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL * url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
    NSLog(@"RequestObject search allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
            NSLog(@"\n\n error = %@\n\n",[error localizedDescription]);
            
        } else {
            NSLog(@"success");
            
            NSLog(@"RequestObject responseObject = %@",responseObject);
            
            [UserInfo sharedUserInfo].searchData = responseObject;
            UpdateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
    
}

//UserInfo Data
+ (void)requestUserInfo {
    
    NSString *urlStr = @"http://www.anyfut.com/member/detail/";
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
    NSLog(@"RequestObject main allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSMutableDictionary *wordDic = [[NSMutableDictionary alloc] init];
        NSString *notificationName = UserInfoNotification;
        wordDic = responseObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil userInfo:wordDic];
            
        });
        
    }];
    
    [dataTask resume];
    
}

//logout
+ (void)requestLogoutData {
    
    NSString *urlStr = @"http://www.anyfut.com/member/logout/";
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSString *notificationName = LogoutNotification;
        
        NSMutableDictionary *wordDic = [[NSMutableDictionary alloc] init];
        wordDic = responseObject;
        
        if ( responseObject != NULL ) {
            
            NSLog(@"\n\n error = %@\n\n",error);
            NSLog(@"\n\n responseObject = %@\n\n",responseObject);
            NSLog(@"\n\n response = %@\n\n",response);
            
        } else {
            
            [UserInfo sharedUserInfo].userToken = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                    object:nil userInfo:wordDic];
                
            });
            
        }
        
    }];
    
    [dataTask resume];
}

//faceBook Login
+ (void)requestFaceBook {
    
}



@end
