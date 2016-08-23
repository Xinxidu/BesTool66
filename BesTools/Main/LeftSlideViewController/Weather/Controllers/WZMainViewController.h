//
//  WZMainViewController.h
//  Weather
//
//  Created by 张武星 on 15/5/25.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZMainViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate>
@property(nonatomic,strong) UIScrollView *contentScrollView;
@property(nonatomic,strong) UIPageViewController *pageController;
@property(nonatomic,strong) UIPageControl *pageControl;
@property(nonatomic,strong) NSMutableArray *viewControllers;
@property(nonatomic,assign) int curPage ;
@property(nonatomic,assign) NSInteger totalPages ;
@property(nonatomic,strong) NSMutableArray *citys;


@end
