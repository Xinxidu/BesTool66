//
//  WZMainViewController.m
//  Weather
//
//  Created by 张武星 on 15/5/25.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZMainViewController.h"
#import "WZWeatherViewController.h"
#import "WZAddCityViewController.h"
#import "WZEditCityViewController.h"
#import "WZFileTool.h"
@implementation WZMainViewController
-(void)viewDidLoad{
    self.navigationController.navigationBarHidden = NO;
    [self configureData];
    [self configureViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityAdded) name:@"CityChangedNotification" object:nil];
}

-(void)configureData{
    self.citys = [WZFileTool readCitysFromFile];
<<<<<<< .merge_file_BKIVQg
    self.totalPages = self.citys.count +1;
=======
    self.totalPages = (int)self.citys.count + 1;
>>>>>>> .merge_file_c7PASs
    self.curPage = 0;
    self.viewControllers = [NSMutableArray array];
    WZWeatherViewController *defalutViewController =[[WZWeatherViewController alloc]init];//
    defalutViewController.page = 0;
    [self.viewControllers addObject:defalutViewController];
    for (int i =0; i<self.citys.count; i++) {
        WZWeatherViewController *tempVC = [[WZWeatherViewController alloc]init];
        tempVC.cityName = self.citys[i];
        tempVC.page = i+1;
        [self.viewControllers addObject:tempVC];
    }
}
-(void)configureViews{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(40, 0, 40, 40)];
    self.pageControl.center = CGPointMake(self.navigationController.navigationBar.bounds.size.width / 2.0, self.navigationController.navigationBar.bounds.size.height / 2.0);
    [self.pageControl addTarget:self action:@selector(pageSelected) forControlEvents:UIControlEventTouchUpInside];
    self.pageControl.numberOfPages = self.totalPages;
    self.pageControl.currentPage = self.curPage;
    self.navigationItem.titleView = self.pageControl;
    //设置导航栏按钮
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gear"] style:UIBarButtonItemStyleDone target:self action:@selector(editCity)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: anotherButton,anotherButton2,nil]];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"plus"] style:UIBarButtonItemStyleDone target:self action:@selector(addCity)];
    
    // 设置UIPageViewController的配置项
    NSDictionary *options =[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey: UIPageViewControllerOptionSpineLocationKey];
    // 实例化UIPageViewController对象，根据给定的属性
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options: options];
    // 设置UIPageViewController对象的代理
    _pageController.dataSource = self;
    // 定义“这本书”的尺寸
    [[_pageController view] setFrame:[[self view] bounds]];
    NSArray *viewControllers =[NSArray arrayWithObjects:self.viewControllers.firstObject, nil];
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    
}

-(void)back{
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"CityChangedNotification" object:nil];
//}

-(void)cityAdded{
    [self configureData];
    self.pageControl.numberOfPages = self.totalPages;
    self.pageControl.currentPage = 0;
     NSArray *viewControllers =[NSArray arrayWithObjects:self.viewControllers.firstObject, nil];
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    self.curPage = ((WZWeatherViewController *)viewController).page;
    self.pageControl.currentPage = self.curPage;
    if (self.curPage<self.totalPages-1) {
        return self.viewControllers[self.curPage+1];
    }else{
        return nil;
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    self.curPage = ((WZWeatherViewController *)viewController).page;
    self.pageControl.currentPage = self.curPage;
    if (self.curPage>0) {
        return self.viewControllers[self.curPage-1];
    }else{
        return nil;
    }
}


-(void)pageSelected{
    
}
-(void)editCity{
    WZEditCityViewController *editCityVC = [[WZEditCityViewController alloc]init];
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:editCityVC];
    [self presentViewController:naviVC animated:YES completion:nil];
    
}
-(void)addCity{
    WZAddCityViewController *addCityVC = [[WZAddCityViewController alloc]init];
    addCityVC.displayType = kDisplayProvince;
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:addCityVC];
    
    [self presentViewController:naviVC animated:YES completion:nil];
    
}

@end
