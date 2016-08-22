//
//  WZHeaderTableViewCell.m
//  Weather
//
//  Created by 张武星 on 15/5/31.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZHeaderTableViewCell.h"
#import "WZWeatherTool.h"

@implementation WZHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)instance{
    WZHeaderTableViewCell *cell;
    cell = [[[NSBundle mainBundle] loadNibNamed:@"WZHeaderTableViewCell" owner:self options:nil]lastObject];
    return cell;
}

-(void)setWeather:(WZWeather *)weather{
    _weather = weather;
    if (weather) {
        WZResults *result = weather.results[0];
        WZWeatherData *weatherData = result.weather_data[0];
        self.weatherImageView.image = [UIImage imageNamed:[WZWeatherTool getWeatherPicWithWeatherName:weatherData.weather]];
        self.weatherLabel.text = weatherData.weather;
        self.pm25ImageView.image = [UIImage imageNamed:[WZWeatherTool getPm25PicWithDegree:result.pm25]];
        self.pm25Label.text = [NSString stringWithFormat:@"%d",result.pm25];
        self.tempRangeLabel.text = weatherData.temperature;
        self.tempLabel.text =  [self extractTempFromData:weatherData.date];
        self.updateDateLabel.text = weather.date;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSString *)extractTempFromData:(NSString *)data{
    //周三(今天, 实时：24℃)
    NSRange startRange = [data rangeOfString:@"："];
    NSRange endRange = [data rangeOfString:@")"];
    if (startRange.length>0) {
        NSRange subStringRange = NSMakeRange(startRange.location +1, endRange.location -startRange.location-1) ;
        return [data substringWithRange:subStringRange];
    }
    return nil;
}
@end
