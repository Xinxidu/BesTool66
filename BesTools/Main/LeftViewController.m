//
//  LeftViewController.m
//  侧滑
//
//  Created by pan on 16/8/9.
//  Copyright © 2016年 pan. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "OtherViewController.h"
#import "ZYTabBarController.h"
#import "WZMainViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];
    
    UITableView *tableview = [[UITableView alloc]init];
    self.tableview = tableview;
    tableview.frame = self.view.bounds;
    tableview.dataSource = self;
    tableview.delegate = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *id = @"id";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:id];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:id];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"开通会员";
    }else if (indexPath.row == 1){
        cell.textLabel.text = @"QQ钱包";
    }else if (indexPath.row == 2){
        cell.textLabel.text = @"网上营业厅";
    }else if (indexPath.row == 3){
        cell.textLabel.text = @"个性装扮";
    }else if (indexPath.row == 4){
        cell.textLabel.text = @"我的收藏";
    }else if (indexPath.row == 5){
        cell.textLabel.text = @"我的相册";
    }else if (indexPath.row == 6){
        cell.textLabel.text = @"联系QQ";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];
    if (indexPath.row == 6) {
        [self chatQQ];//联系QQ
    }else{
        [self.navigationController pushViewController:[[OtherViewController alloc] init] animated:YES];
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    view.backgroundColor = [UIColor clearColor];
    UIButton *weatherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weatherButton.frame = CGRectMake(10, 75, 80, 30);
    [weatherButton setTitle:@"今日天气" forState:UIControlStateNormal];
    [weatherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weatherButton addTarget:self action:@selector(todayWeather:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:weatherButton];
    return view;
}
-(void)todayWeather:(UIButton*)button{
    NSLog(@"weather");
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    WZMainViewController *vc = [[WZMainViewController alloc]init];
    [tempAppDelegate.LeftSlideVC closeLeftView];
    [self.parentViewController.navigationController pushViewController:vc animated:YES];
}
-(void)chatQQ{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        NSString *url = [NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=1129530686&version=1&src_type=web"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"您的设备尚未安装QQ客户端,不能进行QQ临时会话" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:(UIAlertActionStyleDefault) handler:nil];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
