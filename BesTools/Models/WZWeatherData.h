//
//  WZWeatherData.h
//  Weather
//
//  Created by 张武星 on 15/5/22.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "JSONModel.h"
@protocol WZWeatherData
@end
@interface WZWeatherData : JSONModel
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *dayPictureUrl;
@property(nonatomic,copy)NSString *nightPictureUrl;
@property(nonatomic,copy)NSString *weather;
@property(nonatomic,copy)NSString *wind;
@property(nonatomic,copy)NSString *temperature;

@end
