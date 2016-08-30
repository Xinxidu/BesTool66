//
//  ZYTabBarController.m
//  tabbar增加弹出bar
//
//  Created by tarena on 16/7/2.
//  Copyright © 2016年 张永强. All rights reserved.
//

#import "ZYTabBarController.h"
#import "ZYTabBar.h"
#import "ZYNewViewController.h"
#import "MusicViewController.h"
#import "TalkViewController.h"
#import "ReadViewController.h"
#import "AppDelegate.h"
#import "WZMainViewController.h"//天气
#import "LocationMainViewController.h"//地图
#import "HomePageViewController.h"
#import "HistoyrTodayViewController.h"

@interface ZYTabBarController ()<ZYTabBarDelegate>
@property (strong,nonatomic)ZYTabBarController *zy;
@end

@implementation ZYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置子视图
    [self setUpAllChildVc];
    [self configureZYPathButton];
    
}
- (void)configureZYPathButton {
    ZYTabBar *tabBar = [ZYTabBar new];
    tabBar.bardelegate = self;
//    ZYPathItemButton *itemButton_1 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-music"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-music-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    ZYPathItemButton *itemButton_2 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-place"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-place-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    ZYPathItemButton *itemButton_3 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"today"]highlightedImage:[UIImage imageNamed:@"today"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
//    ZYPathItemButton *itemButton_4 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-thought"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-thought-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    
    ZYPathItemButton *itemButton_5 = [[ZYPathItemButton alloc]initWithImage:[UIImage imageNamed:@"chooser-moment-icon-sleep"]highlightedImage:[UIImage imageNamed:@"chooser-moment-icon-sleep-highlighted"]backgroundImage:[UIImage imageNamed:@"chooser-moment-button"]backgroundHighlightedImage:[UIImage imageNamed:@"chooser-moment-button-highlighted"]];
    tabBar.pathButtonArray = @[itemButton_2 , itemButton_3, itemButton_5];
    tabBar.basicDuration = 0.5;
    tabBar.allowSubItemRotation = YES;
    tabBar.bloomRadius = 80;
    tabBar.allowCenterButtonRotation = YES;
    tabBar.bloomAngel = 80;
    //kvc实质是修改了系统的tabBar
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}
- (void)setUpAllChildVc {
    HomePageViewController *HomeVC = [[HomePageViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"home_normal" selectedImage:@"home_highlight" title:@"首页"];
    HomeVC.view.backgroundColor = [UIColor grayColor];
    
    ReadViewController *ReadVC = [[ReadViewController alloc] init];
    [self setUpOneChildVcWithVc:ReadVC Image:@"fish_normal" selectedImage:@"fish_highlight" title:@"奇闻"];
    
    
    TalkViewController *TalkVC = [[TalkViewController alloc] init];
    [self setUpOneChildVcWithVc:TalkVC Image:@"message_normal" selectedImage:@"message_highlight" title:@"聊天"];
    
    MusicViewController *MusicVC = [[MusicViewController alloc] init];
    [self setUpOneChildVcWithVc:MusicVC Image:@"account_normal" selectedImage:@"account_highlight" title:@"音乐"];
}
//点击弹出与隐藏侧试图
-(void)openOrCloseLeftList{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.LeftSlideVC.closed) {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }else{
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:Vc];
    
   // Vc.view.backgroundColor = [self randomColor];
//    Vc.view.backgroundColor = [UIColor whiteColor];
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.tabBarItem.title = title;
    Vc.navigationItem.title = title;
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, 0, 20, 18);
    [menuButton setBackgroundImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(openOrCloseLeftList) forControlEvents:UIControlEventTouchUpInside];
    Vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:menuButton];
    [self addChildViewController:nav];
}
//- (UIColor *)randomColor
//{
//    CGFloat r = arc4random_uniform(256);
//    CGFloat g = arc4random_uniform(256);
//    CGFloat b = arc4random_uniform(256);
//    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
//}
- (void)pathButton:(ZYPathButton *)ZYPathButton clickItemButtonAtIndex:(NSUInteger)itemButtonIndex {
    NSLog(@" 点中了第%ld个按钮" , itemButtonIndex);
    UINavigationController *Vc = [[UINavigationController alloc]initWithRootViewController:[ZYNewViewController new]];
    UINavigationController *Vc1 = [[UINavigationController alloc]initWithRootViewController:[WZMainViewController new]];
    UINavigationController *Vc2 = [[UINavigationController alloc]initWithRootViewController:[LocationMainViewController new]];
        UINavigationController *Vc3 = [[UINavigationController alloc]initWithRootViewController:[HistoyrTodayViewController new]];
  //  Vc.view.backgroundColor = [self randomColor];
    Vc.view.backgroundColor = [UIColor whiteColor];
    if (itemButtonIndex == 0) {
        [self presentViewController:Vc2 animated:YES completion:nil];
    }
    if (itemButtonIndex == 2) {//跳转到天气页面
        [self presentViewController:Vc1 animated:YES completion:nil];
    }else{
        [self presentViewController:Vc3 animated:YES completion:nil];
    }
}

@end
