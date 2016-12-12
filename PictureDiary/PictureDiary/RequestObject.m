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
//    NSURL *requestURL = [NSURL URLWithString:baseURLString];
//    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//    
//    NSURL *URL = requestURL;
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        
//        NSLog(@"%@", response);
//        NSLog(@"%@", error);
//        
//        NSArray *data = responseObject;
//        
//        for(NSDictionary *dic in data){
//            NSLog(@"%@",dic);
//        }
//        
//    }];
//    
//    [dataTask resume];
    
    //새로 작성
    //어렵구만 어려워...... 아니 어렵다기 보단 복잡한데 아직 머릿속에 정리만 잘된다면 이해가 될거같은..
    NSString *urlString = @"http://www.anyfut.com/member/detail/";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token"];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        NSString *notificationName = UserNotification;
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc] init];
        [userDic setObject:responseObject forKey:@"user"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName object:nil userInfo:userDic];
        });
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
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"RequestObject main allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
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


//requestRead
+ (void)requestReadData:(NSString *)PostId {
    
    NSString *urlStr = @"https://www.anyfut.com/post/";
    NSMutableString *urlStrs = [urlStr mutableCopy];
    [urlStrs appendString:PostId];
    
    NSLog(@"RequestObject urlStrs = %@",urlStrs);
    NSURL * url = [NSURL URLWithString:urlStrs];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
//    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
//    [token appendString:[UserInfo sharedUserInfo].userToken];
    NSString *token = [UserInfo sharedUserInfo].userToken;
    NSString *appendToken = @"Token ";
    NSString *resultToken = [appendToken stringByAppendingString:token];
    
//    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
    [urlRequest setValue:resultToken forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"RequestObject readData allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"error!! %@",error);
        }
        
        NSLog(@"response !!!!==== %@",response);
        NSLog(@"responseObject ?????==== %@",responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }];
    
    [dataTask resume];
    
    
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
//    [request setHTTPMethod:@"GET"];
//    
//    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
//    NSString *loginToken = [UserInfo sharedUserInfo].userToken;
//    [token appendString:loginToken];
//    [request setValue:token forHTTPHeaderField:@"Authorization"];
//    [request setURL:url];
//    
//    NSLog(@"RequestObject readData allHTTPHeaderFields : %@",request.allHTTPHeaderFields);
//    NSLog(@"ReqeustObject readData url : %@",request.URL.absoluteString);
//    
//    id taskHandler =^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"request image list response : %@, error: %@",response,error);
//        
//        NSError *jsonParsingError;
//        NSDictionary *jsonResult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&jsonParsingError];
//        NSLog(@"json parsing error : %@, json result : %@",jsonParsingError,jsonResult);
//        
//        NSLog(@"error ===!!!! %@",error);
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//        });
//    };
//    
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:taskHandler
//    ];
//    
//    
//    [dataTask resume];

}

//reuqestModify
+ (void)requestModifyData {
    
}

+ (void)requestDeleteData {
    
}

//requestWrite
+ (void)requestWriteData {
    
}

//requestSearch
+ (void)requestSearch:(NSString *)searchData {
    
    NSString *urlStr = @"https://www.anyfut.com/post/search";
    NSMutableString *urlStrs = [urlStr mutableCopy];
    NSString *searchWord = [NSString stringWithFormat:@"?title=%@",searchData];
    
    [urlStrs appendString:searchWord];
    
    NSCharacterSet *allowedCharacterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSURL *url = [NSURL URLWithString:[urlStrs stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet]];
    
    NSLog(@"RequestObject urlStrs = %@",urlStrs);
    //NSURL * url = [NSURL URLWithString:hanUrl];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"RequestObject readData allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    NSLog(@"ReqeustObject readData url : %@",urlRequest.URL.absoluteString);
    NSLog(@"RequestObject readData Method : %@",urlRequest.HTTPMethod);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            NSLog(@"error!! %@",error);
        }
        
        NSLog(@"response !!!!==== %@",response);
        NSLog(@"responseObject ?????==== %@",responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    }];
    
    [dataTask resume];
    
}

//UserInfo
+ (void)requestUserInfo {
    
    NSString *urlStr = @"http://www.anyfut.com/member/detail/";
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"RequestObject main allHTTPHeaderFields : %@",urlRequest.allHTTPHeaderFields);
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:urlRequest completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        NSMutableDictionary *wordDic = [[NSMutableDictionary alloc] init];
        
        NSString *notificationName = UserInfoNotification;
        
        wordDic = responseObject;
        
        NSLog(@"responseObject ===@@@!! %@",responseObject);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
                                                                object:nil userInfo:wordDic];
            
        });
        
    }];
    
    [dataTask resume];

}

//faceBook Login
+ (void)requestFaceBook {
    
}



@end
