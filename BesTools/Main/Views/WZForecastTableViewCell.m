//
//  WZForecastTableViewCell.m
//  Weather
//
//  Created by 张武星 on 15/5/31.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZForecastTableViewCell.h"
#import "WZForecastItemTableViewCell.h"
#import "WZWeatherTool.h"
@implementation WZForecastTableViewCell

-(void)awakeFromNib{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setWeatherData:(NSArray *)weatherData{
    _weatherData = weatherData;
    [self.tableView reloadData];
}

+(instancetype)instance{
    WZForecastTableViewCell *cell;
    cell = [[[NSBundle mainBundle] loadNibNamed:@"WZForecastTableViewCell" owner:self options:nil]lastObject];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZForecastItemTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"WZForecastItemTableViewCell"];
    if (!itemCell) {
        itemCell = [[[NSBundle mainBundle]loadNibNamed:@"WZForecastItemTableViewCell" owner:self options:nil]lastObject];
        itemCell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        WZWeatherData *data = self.weatherData[indexPath.row +1];
        if (data) {
            itemCell.weekdayLabel.text = data.date;
            itemCell.weatherLabel.text = data.weather;
            itemCell.weatherImageView.image = [UIImage imageNamed:[WZWeatherTool getWeatherPicWithWeatherName:data.weather]];
            itemCell.tempRangeLabel.text = data.temperature;
        }
    }
    return itemCell;
}

@end
