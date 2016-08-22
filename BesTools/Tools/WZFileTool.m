//
//  WZFileTool.m
//  Weather
//
//  Created by 张武星 on 15/5/23.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZFileTool.h"
#import "WZWeather.h"
@implementation WZFileTool

+(void)writeWeatherToFile:(WZWeather *)weather withCity:(NSString *)city{
    if (!city) {
        city = @"default";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths objectAtIndex:0];//获取根目录
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:weather];
    NSString *filePath = [rootPath stringByAppendingPathComponent:city];
    [data writeToFile:filePath atomically:YES];
}

+(WZWeather *)readWeatherFromFileWithCity:(NSString *)city{
    if (!city) {
        city= @"default";
    }
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths objectAtIndex:0];//获取根目录
    NSString *filePath = [rootPath stringByAppendingPathComponent:city];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    WZWeather *weather = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return weather;
}

+(void)writeCitysToFile:(NSMutableArray *)citys{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths objectAtIndex:0];//获取根目录
    NSString *filePath = [rootPath stringByAppendingPathComponent:@"cityList"];
    
    
    [citys writeToFile:filePath atomically:YES];
}
+(NSMutableArray *)readCitysFromFile{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *rootPath = [paths objectAtIndex:0];//获取根目录
    NSString *filePath = [rootPath stringByAppendingPathComponent:@"cityList"];
    NSMutableArray *citys = [NSMutableArray arrayWithContentsOfFile:filePath];
    if (!citys) {
        citys = [NSMutableArray array];
    }
    return citys;
}
@end