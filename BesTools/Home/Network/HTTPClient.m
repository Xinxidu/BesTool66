//
//  HTTPClient.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HTTPClient.h"
#import "HTTPURLConfiguration.h"
#import "HTTPManager.h"
#import "LatestNewsResponseModel.h"
#import "NewsListResponseModel.h"
#import "DetailNewsResponseModel.h"
#import "ThemesListResponseModel.h"
#import "ThemeDetailResponseModel.h"
#import "LaunchImageResponseModel.h"

@interface HTTPClient ()

@property (nonatomic, strong) HTTPManager *httpManager;

@end

@implementation HTTPClient

SYNTHESIZE_SINGLETON_FOR_CLASS(HTTPClient)

- (id)init{
    if (self = [super init]) {
        _httpManager = [HTTPManager new];
    }
    
    return self;
}

- (NSURLSessionDataTask *)getLatestNewsWithSuccess:(HttpClientSuccessBlock)success
                                              fail:(HttpClientFailureBlock)fail{
    NSString *relativePath = [[HTTPURLConfiguration sharedInstance] latestNews];

    return [_httpManager GET:relativePath parameters:nil modelClass:[LatestNewsResponseModel class] success:success failure:fail];
}

- (NSURLSessionDataTask *)getPreviousNewsWithDate:(NSString *)date success:(HttpClientSuccessBlock)success
                                             fail:(HttpClientFailureBlock)fail{
    NSString *relativePath = [[HTTPURLConfiguration sharedInstance] previousNews];
    if (date) {
        relativePath = [relativePath stringByAppendingString:date];
    }
    
    return [_httpManager GET:relativePath parameters:nil modelClass:[NewsListResponseModel class] success:success failure:fail];
}

- (NSURLSessionDataTask *)getDetailNewsWithID:(NSInteger)storyID success:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail{
    NSString *relativePath = [[HTTPURLConfiguration sharedInstance] detailNews];

    relativePath = [relativePath stringByAppendingFormat:@"%ld",(long)storyID];
    
    return [_httpManager GET:relativePath parameters:nil modelClass:[DetailNewsResponseModel class] success:success failure:fail];
}

- (NSURLSessionDataTask *)getThemesListWithSuccess:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail{
    NSString *relativePath = [[HTTPURLConfiguration sharedInstance] themesList];
    
    return [_httpManager GET:relativePath parameters:nil modelClass:[ThemesListResponseModel class] success:success failure:fail];
}

- (NSURLSessionDataTask *)getThemeWithThemeID:(NSInteger)themeID success:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail{
    NSString *relativePath = [[HTTPURLConfiguration sharedInstance] theme];
    
    relativePath = [relativePath stringByAppendingFormat:@"%ld",(long)themeID];
    
    return [_httpManager GET:relativePath parameters:nil modelClass:[ThemeDetailResponseModel class] success:success failure:fail];
}

- (NSURLSessionDataTask *)getLaunchImageWithResolution:(NSString *)resolution success:(HttpClientSuccessBlock)success fail:(HttpClientFailureBlock)fail{
    NSString *relativePath = [[HTTPURLConfiguration sharedInstance] launchImage];
    
    relativePath = [relativePath stringByAppendingString:resolution];
    
    return [_httpManager GET:relativePath parameters:nil modelClass:[LaunchImageResponseModel class] success:success failure:fail];
}

@end
