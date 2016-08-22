//
//  WZAddCityViewController.h
//  Weather
//
//  Created by 张武星 on 15/5/26.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kDisplayProvince 0
#define kDisplayCity 1
#define kDisplayArea 2
@interface WZAddCityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,assign)int displayType;
@property(nonatomic,strong)NSArray *provinces;
@property(nonatomic,strong)NSArray *citys;
@property(nonatomic,strong)NSArray *areas;
@property(nonatomic,strong)NSString *selectedCity;
@property(nonatomic,strong)NSString *selectedArea;
@end
