//
//  WZWeatherTool.h
//  Weather
//
//  Created by 张武星 on 15/5/22.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "JSONModel.h"

@interface WZWeatherTool : JSONModel
+(NSString *)getBackgroundImageWithWeatherName:(NSString *)weatherName;
+(NSString *)getWeatherPicWithWeatherName:(NSString *)weatherName;
+(NSString *)getIndexPicWithRow:(int)row;
+(NSString *)getPm25PicWithDegree:(int)degree;
@end
