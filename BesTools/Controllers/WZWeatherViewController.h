//
//  ViewController.h
//  Temperature
//
//  Created by 张武星 on 15/5/18.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WZLocationTool.h"
@interface WZWeatherViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,WZLocationToolDelegate>
@property (strong, nonatomic)  UIImageView *backgroundImageView;
@property(nonatomic,strong)  UILabel *cityLabel;
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,copy) NSString *cityName;
@property(nonatomic,assign)int page;
@end

