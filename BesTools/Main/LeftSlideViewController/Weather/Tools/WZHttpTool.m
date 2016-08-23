//
//  WZHttpTool.m
//  Weather
//
//  Created by 张武星 on 15/5/20.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZHttpTool.h"
#import "WZWeather.h"
#import "WZConstants.h"
@implementation WZHttpTool
+ (WZHttpTool *)sharedHttpTool{
    static WZHttpTool *httpTool = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        httpTool = [[WZHttpTool alloc]init];
    });
    return httpTool;
}

-(void)weatherRequestWithCityInfo:(NSString *)cityInfo
                                        success:(void(^)(id)) success
                                        failure:(void(^)(id)) failure{
    NSString *urlString = [NSString stringWithFormat:@"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&mcode=com.ccs.Weather&ak=%@",cityInfo,kBaiduKey];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        WZWeather *weather = [[WZWeather alloc]initWithDictionary:resp error:nil];
        if (weather) {
            success(weather);
        }
    }];
    [task resume];
}
@end
