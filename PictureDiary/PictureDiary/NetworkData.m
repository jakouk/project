//
//  NetworkData.m
//  PictureDiary
//
//  Created by jakouk on 2016. 11. 28..
//  Copyright © 2016년 jakouk. All rights reserved.
//

#import "NetworkData.h"
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeImageList,
    RequestTypeUploadImage,
    RequestTypeDeleteImage
};

static NSString *const baseURLString = @"http://iosschool.yagom.net:8080/";

static NSString *ParamNameUserIDKey = @"user_id";
static NSString *ParamNameImageTitleKey = @"title";
static NSString *ParamNameImageDataKey = @"image_data";
static NSString *ParamNameImageIdKey = @"image_id";
static NSString *JSONContentKey = @"list";
static NSString *JSONResultKey = @"result";

static NSString *JSONSuccessValue = @"success";


@implementation NetworkData

+ (NSURL *)requestURL:(RequestType)type param:(NSDictionary *)paramDic {
    
    NSMutableString *urlString = [baseURLString mutableCopy];
    
    switch (type) {
        case RequestTypeImageList:
            [urlString appendString:@"api/list"];
            break;
        case RequestTypeUploadImage:
            [urlString appendString:@"api/upload"];
            break;
        case RequestTypeDeleteImage:
            [urlString appendString:@"api/image"];
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


@end
