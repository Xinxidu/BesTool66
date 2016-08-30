//
//  LeftViewController.m
//  侧滑
//
//  Created by pan on 16/8/9.
//  Copyright © 2016年 pan. All rights reserved.
//

#import "LeftViewController.h"
#import "AppDelegate.h"
#import "LeftMenuTableViewCell.h"
#import "OtherViewController.h"
#import "ZYTabBarController.h"
#import "WZMainViewController.h"
#import "SingleThemeResponseModel.h"
#import "ThemeDailyViewController.h"
#import "ThemesListResponseModel.h"
@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *_headImageView;
}
@property (strong, nonatomic) NSMutableArray<SingleThemeResponseModel *> *dataArray;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) ThemeDailyViewController *themeDailyViewController;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = [NSMutableArray arrayWithCapacity:14];
    _selectedIndex = 0;
    // Do any additional setup after loading the view.
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageview.image = [UIImage imageNamed:@"leftbackiamge"];
    [self.view addSubview:imageview];
    [self loadData];
    [self loadUI];
}
-(void)loadUI{
    //self.view.themeMap = @{kThemeMapKeyColorName : @"left_menu_bg"};
    self.tableview=[[UITableView alloc]init];
    _tableview.frame = CGRectMake(0, 0, self.view.frame.size.width, 500);
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableview];
    [self.tableview registerClass:[LeftMenuTableViewCell class] forCellReuseIdentifier:@"cell"];
}
-(void)loadData{
    SingleThemeResponseModel *homeModel = [[SingleThemeResponseModel alloc] initWithDictionary:@{@"name":@"首页",@"themeID":@(-1)} error:nil];
    [_dataArray addObject:homeModel];
    
    [[HTTPClient sharedInstance] getThemesListWithSuccess:^(NSURLSessionDataTask *task,BaseResponseModel *model){
        ThemesListResponseModel *themesModel = (ThemesListResponseModel *)model;
        [self.dataArray addObjectsFromArray:themesModel.others];
        //NSLog(@"_dataArray=======%@",_dataArray);
        [self.tableview reloadData];
    }fail:^(NSURLSessionDataTask *task, BaseResponseModel *model){
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[LeftMenuTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    SingleThemeResponseModel *singleModel = self.dataArray[indexPath.row];
    cell.textLabel.text = singleModel.name;
    
    if (indexPath.row == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"Menu_Icon_Home"]];
    }
    else
        [cell.imageView setImage:nil];
    
    if (_selectedIndex == indexPath.row) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndex = indexPath.row;
    if (indexPath.row != 0) {
        if (self.themeDailyViewController) {
            self.themeDailyViewController.themeID = _dataArray[indexPath.row].themeID;
            self.themeDailyViewController.titleName = _dataArray[indexPath.row].name;
            self.themeDailyViewController.sideMenuViewController = self.sideMenuController;
            [self.themeDailyViewController reloadData];
        }
        else{
            self.themeDailyViewController = [ThemeDailyViewController new];
            self.themeDailyViewController.themeID = _dataArray[indexPath.row].themeID;
            self.themeDailyViewController.titleName = _dataArray[indexPath.row].name;
            self.themeDailyViewController.sideMenuViewController = self.sideMenuController;
        }
    }
    else{
      NSLog(@"%ld",indexPath.row);
    }
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC closeLeftView];
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section{
    return 150;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section{
    return 50;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
    view.backgroundColor = [UIColor clearColor];
    //------ 设置 ------
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(100, 10, 35, 35);
    [collectBtn setImage:[UIImage imageNamed:@"Menu_Icon_Collect"] forState:UIControlStateNormal];
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(140, 10, 35, 35);
    [messageBtn setImage:[UIImage imageNamed:@"Menu_Icon_Message"] forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(chatQQ) forControlEvents:UIControlEventTouchUpInside];
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    setBtn.frame = CGRectMake(180, 10, 35, 35);
    [setBtn setImage:[UIImage imageNamed:@"Menu_Icon_Setting"] forState:UIControlStateNormal];
    [view addSubview:collectBtn];
    [view addSubview:messageBtn];
    [view addSubview:setBtn];
    return view;
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 150)];
    view.backgroundColor = [UIColor clearColor];
    //------ 头像 ------
    _headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 40, 80, 80)];
    _headImageView.layer.borderColor = [UIColor colorWithRed:55/255.0 green:134/255.0 blue:226/255.0 alpha:1].CGColor;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.cornerRadius = 40;
    _headImageView.image = [UIImage imageNamed:@"login_user"];
    [view addSubview:_headImageView];
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(95, 65, 80, 30);
    [loginButton setTitle:@"未登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view addSubview:loginButton];
    return view;
}
//联系QQ
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
