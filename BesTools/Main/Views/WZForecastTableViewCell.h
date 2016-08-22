//
//  WZForecastTableViewCell.h
//  Weather
//
//  Created by 张武星 on 15/5/31.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZWeather.h"
@interface WZForecastTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *weatherData;
+(instancetype)instance;
@end
