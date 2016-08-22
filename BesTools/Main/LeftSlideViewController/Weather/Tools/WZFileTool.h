//
//  WZFileTool.h
//  Weather
//
//  Created by 张武星 on 15/5/23.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WZWeather.h"
@interface WZFileTool : NSObject
+(void)writeWeatherToFile:(WZWeather *)weather withCity:(NSString *)city;
+(WZWeather *)readWeatherFromFileWithCity:(NSString *)city;
+(void)writeCitysToFile:(NSMutableArray *)citys;
+(NSMutableArray *)readCitysFromFile;
@end
