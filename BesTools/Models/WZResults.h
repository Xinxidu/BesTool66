//
//  WZResults.h
//  Weather
//
//  Created by 张武星 on 15/5/22.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "JSONModel.h"
#import "WZIndex.h"
#import "WZWeatherData.h"
@protocol WZResults
@end


@interface WZResults : JSONModel
@property(nonatomic,copy)NSString *currentCity;
@property(nonatomic,assign)int pm25;
@property(nonatomic,strong)NSArray<WZIndex>  *index;
@property(nonatomic,strong)NSArray<WZWeatherData> *weather_data;
@end
