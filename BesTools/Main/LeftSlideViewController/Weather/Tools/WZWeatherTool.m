//
//  WZWeatherTool.m
//  Weather
//
//  Created by 张武星 on 15/5/22.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZWeatherTool.h"

@implementation WZWeatherTool
+(NSString *)getBackgroundImageWithWeatherName:(NSString *)weatherName{
    if ([@"晴" containsString:weatherName] ) {
        
        return @"bg_fine_day";
        
    }else if ([@"多云" containsString:weatherName]){
        
        return @"bg_cloudy_day";
        
    }else if ([@"阴" containsString:weatherName]){
        
        return @"bg_overcast";
        
    }else if([@"阵雨|小雨|中雨|大雨|暴雨|大暴雨|特大暴雨|小雨转中雨|中雨转大雨|大雨转暴雨|暴雨转大暴雨|大暴雨转特大暴雨|冻雨" containsString:weatherName]){
        
        return @"bg_rain";
        
    }else if ([@"雷阵雨|雷阵雨伴有冰雹" containsString:weatherName]){
        
        return @"bg_thunder_storm";
        
    }else if ([@"雨夹雪|阵雪|小雪|中雪|大雪|暴雪|小雪转中雪|中雪转大雪|大雪转暴雪" containsString:weatherName]){
        
        return @"bg_snow";
        
    }else if([@"沙尘暴|浮尘|扬沙|强沙尘暴" containsString:weatherName]){
        
        return @"bg_sand_storm";
        
    }else if ([@"雾" containsString:weatherName]){
        
        return @"bg_fog";
        
    }else if ([@"霾" containsString:weatherName]){
        
        return @"bg_haze";
    }else{
     
        return @"bg_na";
    }
}

+(NSString *)getWeatherPicWithWeatherName:(NSString *)weatherName{
    if ([@"晴" containsString:weatherName] ) {
        
        return @"ic_sunny_big";
        
    }else if ([@"多云" containsString:weatherName]){
        
        return @"ic_cloudy_big";
        
    }else if ([@"阴" containsString:weatherName]){
        
        return @"ic_overcast_big";
        
    }else if([@"阵雨|小雨|中雨|大雨|暴雨|大暴雨|特大暴雨|小雨转中雨|中雨转大雨|大雨转暴雨|暴雨转大暴雨|大暴雨转特大暴雨|冻雨" containsString:weatherName]){
        
        return @"ic_lightrain_big";
        
    }else if ([@"雷阵雨|雷阵雨伴有冰雹" containsString:weatherName]){
        
        return @"ic_thundeshowehail_big";
        
    }else if ([@"雨夹雪|阵雪|小雪|中雪|大雪|暴雪|小雪转中雪|中雪转大雪|大雪转暴雪" containsString:weatherName]){
        
        return @"ic_snow_big";
        
    }else if([@"沙尘暴|浮尘|扬沙|强沙尘暴" containsString:weatherName]){
        
        return @"ic_sandstorm_big";
        
    }else if ([@"雾" containsString:weatherName]){
        
        return @"ic_fog_big";
        
    }else if ([@"霾" containsString:weatherName]){
        
        return @"ic_haze_big";
    }else{
        
        return @"ic_default_big";
    }


}



+(NSString *)getPm25PicWithDegree:(int)degree{
    if (degree <50) {
        return @"ic_pm25_01";
    }else if (degree<100){
        return @"ic_pm25_02";
    }else if (degree<200){
        return @"ic_pm25_03";
    }else{
        return @"ic_pm25_04";
    }


}
+(NSString *)getIndexPicWithRow:(int )row{
    switch (row) {
        case 0:
            return @"ic_lifeindex_clothes";
            break;
        case 1:
            return @"ic_lifeindex_carwash";
            break;
        case 2:
            return @"ic_lifeindex_tour";
            break;
        case 3:
            return @"ic_lifeindex_cold";
            break;
        case 4:
            return @"ic_lifeindex_sport";
            break;
        case 5:
            return @"ic_lifeindex_ultravioletrays";
            break;
            
        default:
            return nil;
            break;
    }

}
@end
