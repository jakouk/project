//
//  RequestObject.m
//  PictureDiary
//
//  Created by jakouk on 2016. 12. 3..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "RequestObject.h"

@implementation RequestObject

//reqeustMehotd
+ (NSMutableURLRequest *)requestURL:(NSURL *)url httpMethod:(NSString *)httpMethod{
    
    NSMutableURLRequest *urlRequest =  [NSMutableURLRequest requestWithURL:url];
    
    if ( ![httpMethod isEqualToString:@"POST"] ) {
        [urlRequest setHTTPMethod:httpMethod];
    }
    
    [self urlRequestToken:urlRequest];
    
    return urlRequest;
}

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

//AddToken
+ (void)urlRequestToken:(NSMutableURLRequest *)urlRequest{
    
    NSMutableString *token = [NSMutableString stringWithFormat:@"Token "];
    [token appendString:[UserInfo sharedUserInfo].userToken];
    [urlRequest setValue:token forHTTPHeaderField:@"X-Authorization"];
    
}



@end
