//
//  WZForecastItemTableViewCell.h
//  Temperature
//
//  Created by 张武星 on 15/5/18.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZForecastItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UILabel *tempRangeLabel;

@end
