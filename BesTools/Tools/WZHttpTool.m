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
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request =
    [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init]completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        WZWeather *weather = [[WZWeather alloc]initWithDictionary:resp error:nil];
        if (weather) {
            success(weather);
        }
    }];
}
@end
