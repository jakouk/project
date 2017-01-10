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
    RequestTypeReadData,
    RequestTypeSearchData,
    RequestTypeWrite,
    RequestTypeLogout,
    RequestTypeUserInfo,
    RequestTypeReadModify,
    RequestTypeDelete
};

//baseURL
static NSString *const baseURLString = @"http://team1photodiary.ap-northeast-2.elasticbeanstalk.com/";

//Parameter
static NSString *ParamNameUserIDKey = @"email";
static NSString *ParamNameUserNameKey = @"username";
static NSString *ParamNameUserPassWordKey = @"password";
static NSString *ParamNamePostTitle = @"title";
static NSString *ParamNamePostContent = @"content";

//URL
static NSString *const URLNameLogin = @"member/login/";
static NSString *const URLNameJoin = @"member/create/";
static NSString *const URLNameMain = @"post/";
static NSString *const URLNameSearch = @"post/search";
static NSString *const URLNameLogout = @"member/logout/";
static NSString *const URLNameUserInfo = @"member/detail/";

static NSString *JSONSuccessValue = @"success";

@implementation RequestObject

//POSTtype make method
+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic postData:(NSString *)PostData {
    
    NSMutableString *urlString = [baseURLString mutableCopy];
    
    switch (type) {
        case RequestTypeJoin:
            [urlString appendString:URLNameJoin];
            break;
        case RequestTypeLogin:
            [urlString appendString:URLNameLogin];
            break;
        case RequestTypeMainData:
            [urlString appendString:URLNameMain];
            break;
        case RequestTypeReadData:
            [urlString appendString:URLNameMain];
            break;
        case RequestTypeUserInfo:
            [urlString appendString:URLNameUserInfo];
            break;
        case RequestTypeLogout:
            [urlString appendString:URLNameLogout];
            break;
        case RequestTypeSearchData:
            [urlString appendString:URLNameSearch];
            break;
        case RequestTypeReadModify:
            [urlString appendString:URLNameMain];
            break;
        case RequestTypeDelete:
            [urlString appendString:URLNameMain];
            break;
        case RequestTypeWrite:
            [urlString appendString:URLNameMain];
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
    
    if (PostData) {
        [urlString appendString:PostData];
    }
    
    return [NSURL URLWithString:urlString];
}

//reqeustMehotd
+ (NSMutableURLRequest *)requestURL:(NSURL *)url httpMethod:(NSString *)httpMethod{
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    
    if ( ![httpMethod isEqualToString:@"POST"] ) {
        [urlRequest setHTTPMethod:httpMethod];
    }
    
    [self urlRequestToken:urlRequest];
    
    return urlRequest;
}

//AddToken
+ (void)urlRequestToken:(NSMutableURLRequest *)urlRequest{
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
}

//ServerCheck ( GET )
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
    
    NSString *requestURL = [[self requestURL:RequestTypeJoin
                                       param:nil
                                    postData:nil] absoluteString];
    
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
//requestMain ( GET )
+ (void)requestMainData {
    
    NSURL * url = [self requestURL:RequestTypeMainData
                             param:nil
                          postData:nil];
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSString *notificationName = MainNotification;
        
        NSMutableDictionary *wordDic = [[NSMutableDictionary alloc] init];
        wordDic = responseObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil userInfo:wordDic];
            
        });
        
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


//requestRead ( GET )
+ (void)requestReadData:(NSString *)PostId {
    
    NSURL * url = [self requestURL:RequestTypeReadData
                             param:nil
                          postData:PostId];
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSString *notificationName = ReadNotification;
        
        NSMutableDictionary *wordDic = [[NSMutableDictionary alloc] init];
        wordDic = responseObject;
        
        NSLog(@"\n\n response : %@ \n\n",response);
        [UserInfo sharedUserInfo].readData = responseObject;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil userInfo:wordDic];
        });
        
    }];
    [dataTask resume];

}


//requestDelete ( DELETE )
#pragma mark -requestDelete
+ (void)requestDeleteData:(NSString *)deletaData pdateFinishDataBlock:(UpdateFinishDataBlock)UpdateFinishDataBlock {
    
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
                      
                      NSLog(@"\n\n response : %@ \n\n",response);
                      NSLog(@"\n\n responseObject : %@ \n\n",responseObject);
                      NSLog(@"\n\n error : %@ \n\n",error);
                      
                      if (error == NULL) {
                          UpdateFinishDataBlock();
                      }
                  }];
    
    [uploadTask resume];
}


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
            
            NSLog(@"\n\n error = %@\n\n",[error localizedDescription]);
            
        } else {
            
            [UserInfo sharedUserInfo].searchData = responseObject;
            UpdateFinishDataBlock();
        }
        
    }];
    
    [dataTask resume];
    
}


//UserInfo Data ( GET )
+ (void)requestUserInfo {
    
    NSURL * url = [self requestURL:RequestTypeUserInfo
                             param:nil
                          postData:nil];
    
    NSMutableURLRequest *urlRequest = [self requestURL:url httpMethod:@"GET"];
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

//logout ( GET )
+ (void)requestLogoutData {
    
    NSURL *url = [self requestURL:RequestTypeLogout
                            param:nil
                         postData:nil];
    NSMutableURLRequest *urlRequest =  [self requestURL:url httpMethod:@"GET"];
    
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
