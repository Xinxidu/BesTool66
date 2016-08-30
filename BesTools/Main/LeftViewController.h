//
//  LeftViewController.h
//  侧滑
//
//  Created by pan on 16/8/9.
//  Copyright © 2016年 pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@class HomePageViewController;
@class SideMenuViewController;
@interface LeftViewController : BaseViewController
@property (strong,nonatomic) UITableView *tableview;
@property (nonatomic, weak) HomePageViewController *homePageViewController;
@property (nonatomic, weak) SideMenuViewController *sideMenuController;
@end
