//
//  WZAddCityViewController.m
//  Weather
//
//  Created by 张武星 on 15/5/26.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZAddCityViewController.h"
#import "WZFileTool.h"
@interface WZAddCityViewController()

@end


@implementation WZAddCityViewController


-(void)viewDidLoad{
    [self configureData];
    [self configureViews];

}

-(void)configureData{
    if (self.displayType == kDisplayProvince) {
        NSString *addressPath = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithContentsOfFile:addressPath];
        self.provinces = [dict objectForKey:@"address"];
    }
}

-(void)configureViews{
    if (self.displayType == kDisplayProvince) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    }
    if (self.displayType == kDisplayCity) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(submit)];
    }
    CGRect frame = [self.view bounds];
    self.tableView = [[UITableView alloc]initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.displayType == kDisplayProvince) {
        return self.provinces.count;
    }else if (self.displayType == kDisplayCity){
        return self.citys.count;
    }else{
        return self.areas.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* ID = @"cityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
       
        if (self.displayType == kDisplayCity) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if (self.displayType == kDisplayProvince) {
         cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        NSDictionary *province = self.provinces[indexPath.row];
        NSString *provinceName = [province objectForKey:@"name"];
        cell.textLabel.text= provinceName;
    }else if (self.displayType == kDisplayCity){
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *city = self.citys[indexPath.row];
        NSString *cityName = [city objectForKey:@"name"];
        cell.textLabel.text= cityName;
        if ([self.selectedCity isEqualToString:cityName]) {
            cell.imageView.image = [UIImage imageNamed:@"checked"];
        }else{
            cell.imageView.image = [UIImage imageNamed:@"unchecked"];
        }
    }else{
        cell.textLabel.text= self.areas[indexPath.row];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.displayType == kDisplayProvince) {
        NSDictionary *province = self.provinces[indexPath.row];
        NSArray *citys = [province objectForKey:@"sub"];
        WZAddCityViewController *cityVC = [[WZAddCityViewController alloc]init];
        cityVC.displayType = kDisplayCity;
        cityVC.citys = citys;
        [self.navigationController pushViewController:cityVC animated:YES];
    }else if (self.displayType == kDisplayCity){
        NSDictionary *city = self.citys[indexPath.row];
        self.selectedCity = [city objectForKey:@"name"];
        [tableView reloadData];
//        NSArray *areas = [city objectForKey:@"sub"];
//        NSString *cityName = [city objectForKey:@"name"];
//        WZAddCityViewController *areaVC = [[WZAddCityViewController alloc]init];
//        areaVC.displayType = kDisplayArea;
//        areaVC.areas = areas;
//        areaVC.selectedCity = cityName;
//        [self.navigationController pushViewController:areaVC animated:YES];
    }
        //else{
//        self.selectedArea = self.areas[indexPath.row];
//    }

}
-(void)submit{
    NSMutableArray *citys = [WZFileTool readCitysFromFile];
    [citys addObject:self.selectedCity];
    [WZFileTool writeCitysToFile:citys];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CityChangedNotification" object:nil];
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
