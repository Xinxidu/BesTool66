//
//  WZHeaderTableViewCell.h
//  Weather
//
//  Created by 张武星 on 15/5/31.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZWeather.h"
@interface WZHeaderTableViewCell : UITableViewCell
@property(nonatomic,weak) WZWeather *weather;

@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;
@property (weak, nonatomic) IBOutlet UIImageView *pm25ImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;

+(instancetype)instance;
@end
