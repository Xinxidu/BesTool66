//
//  ViewController.m
//  Temperature
//
//  Created by 张武星 on 15/5/18.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZWeatherViewController.h"
#import "UIImageView+LBBlurredImage.h"
#import "WZHttpTool.h"
#import "WZWeather.h"
#import "WZConstants.h"
#import "WZFileTool.h"
#import "WZWeatherTool.h"
#import "WZHeaderTableViewCell.h"
#import "WZTitleTableViewCell.h"
#import "WZForecastTableViewCell.h"
#import "WZIndexTableViewCell.h"
@interface WZWeatherViewController ()
@property(nonatomic,strong) WZWeather *weather;
@property(nonatomic,strong) WZResults *result;
@property(nonatomic,strong) NSArray *index;
@property(nonatomic,strong) NSArray *weatherData;
@property(nonatomic,strong) WZLocationTool *locationTool;
@end

@implementation WZWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureData];
    [self configureViews];
    [self loadViews];
    if (self.cityName) {
        [self requestWithCityInfo:self.cityName];
    }else{
        [self startLocation];
    }
}

#pragma mark 自定义方法

-(void)configureData{
    WZWeather *cachedWeather = [WZFileTool readWeatherFromFileWithCity:self.cityName];
    if (cachedWeather) {
        self.result = cachedWeather.results[0];
        self.index = self.result.index;
        self.weatherData = self.result.weather_data;
        self.weather = cachedWeather;
    }
}
-(void)configureViews{
    CGRect frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:frame];
    [self.view addSubview:self.backgroundImageView];
    // cityLabel
    self.cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:75];
    self.cityLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.cityLabel];
    // tableview
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
}

-(void)loadViews{
    //load background image
    UIImage *blurImage;
    if (self.weather) {
        WZWeatherData *todayWeatherData = self.weatherData[0];
        NSString *todayWeather = todayWeatherData.weather;
        blurImage = [UIImage imageNamed:[WZWeatherTool getBackgroundImageWithWeatherName:todayWeather]];
    }else{
        blurImage = [UIImage imageNamed:@"bg_na"];
    }
      self.backgroundImageView.image = blurImage;
    //load city name
    if (self.cityName) {
        self.cityLabel.text = self.cityName;
    }else{
        self.cityLabel.text = self.result.currentCity;
    }
    //load tableview
    [self.tableView reloadData];
}
// start location
-(void)startLocation{
    self.locationTool = [[WZLocationTool alloc]init];
    self.locationTool.delegate = self;
    [self.locationTool startLocationManager];
}



// 1
#pragma mark - UITableViewDataSource

// 2
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *WZHeaderTableViewCellID = @"WZHeaderTableViewCell";
    WZHeaderTableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:WZHeaderTableViewCellID];
    if (!headerCell) {
        headerCell = [WZHeaderTableViewCell instance];
    }
    static NSString *WZTitleTableViewCellID = @"WZTitleTableViewCell";
    WZTitleTableViewCell *titleCell = [tableView dequeueReusableCellWithIdentifier:WZTitleTableViewCellID];
    if (!titleCell) {
        titleCell = [WZTitleTableViewCell instance];
    }
    static NSString *WZForecastTableViewCellID  = @"WZForecastTableViewCell";
    WZForecastTableViewCell *forecastCell = [tableView dequeueReusableCellWithIdentifier:WZForecastTableViewCellID];
    if (!forecastCell) {
        forecastCell = [WZForecastTableViewCell instance];
    }
    static NSString *WZIndexTableViewCellID  = @"WZIndexTableViewCell";
    WZIndexTableViewCell *indexCell = [tableView dequeueReusableCellWithIdentifier:WZIndexTableViewCellID];
    if (!indexCell) {
        indexCell = [WZIndexTableViewCell instance];
    }

    if (indexPath.section == 0) {
        if (self.weather) {
            headerCell.weather = self.weather;
        }
        return headerCell;
    }if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            titleCell.titleLabel.text =@"预报";
            return titleCell;
        }else{
            if (self.weatherData) {
                forecastCell.weatherData = self.weatherData;
                return forecastCell;
            }
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            titleCell.titleLabel.text =@"指数";
            return titleCell;
        }else{
            if (self.index) {
                indexCell.wzIndex = self.index;
                return indexCell;
            }
        }
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.view.frame.size.height/2;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44;
        }
        return 44*3;
    }else{
        if (indexPath.row == 0) {
            return 44;
        }
        return 136 * 6;
    }
}

#pragma mark - WZLocation Delegate
-(void)locationReceived:(CLLocation *)location{
    //request weather information
    NSString *cityInfo = [NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude];
    [self requestWithCityInfo:cityInfo];
}

-(void)locationFailed{
    // if location failed ，request beijing weather
    NSString *cityInfo = @"北京市";
    [self requestWithCityInfo:cityInfo];
}


-(void)requestWithCityInfo:(NSString *)cityInfo{
    [kWZHttpTool weatherRequestWithCityInfo:cityInfo success:^(WZWeather *weather) {
        if (! self.cityName ) {
             [WZFileTool writeWeatherToFile:weather withCity:nil];
        }else{
            [WZFileTool writeWeatherToFile:weather withCity:cityInfo];
        }
        self.result = weather.results[0];
        self.index = self.result.index;
        self.weatherData = self.result.weather_data;
        self.weather = weather;
        [self loadViews];
    } failure:nil];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
