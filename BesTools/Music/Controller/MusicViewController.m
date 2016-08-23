//
//  MusicViewController.m
//  BesTools
//
//  Created by Aaron Lee on 16/8/22.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "MusicViewController.h"
#import "SingingViewController.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "TableViewCell.h"
#import "ZYTabBarController.h"
@interface MusicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *listArray;
@property (nonatomic, retain) SingingViewController *SingVC;
@end

@implementation MusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    self.listArray = [[NSMutableArray alloc]init];
    self.SingVC = [[SingingViewController alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        
        self.listArray = [self requestWithUrlString:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
        });
        
    });
    
    [self creatTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)requestWithUrlString:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSArray *array = [NSArray arrayWithContentsOfURL:url];
    //    NSLog(@"--------%@", array); // 接收请求的结果
    NSMutableArray *dataArray = [NSMutableArray array];
    for (NSDictionary *item in array) {
        MusicModel *model = [[MusicModel alloc] init];
        [model setValuesForKeysWithDictionary:item];
        [dataArray addObject:model];
    }
    return dataArray;
}
- (void)creatTableView{
    
    
    self.tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"diaodiaodiao.jpg"]];
    
    imageView.alpha = 0.7;
    
    imageView.frame = [UIScreen mainScreen].bounds;
    
    
    [self.tableView setBackgroundView:imageView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    MusicModel *model = [[MusicModel alloc]init];
    
    model = [self.listArray objectAtIndex:indexPath.row];
    
    
    
    
    //NSLog(@"%@",model.name);
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        
        cell = [[TableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
        
    }
    cell.model = model;
    
    
    
    //    cell.textLabel.text = model.name;
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    
    //    加动画
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *imageViewWait = [[UIImageView alloc]initWithFrame:CGRectMake(200, 10, 150, 150)];
    
    imageViewWait.layer.cornerRadius = 75;
    
    imageViewWait.image = [UIImage imageNamed:@"iconfont-yinlemusic216.png"];
    
    
    [view addSubview:imageViewWait];
    
    cell.selectedBackgroundView = view;
    
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//
//    return 20;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    self.SingVC.listArray = [[NSMutableArray alloc]init];
    
    self.SingVC.listArray = self.listArray;
    
    
    
    if (self.SingVC.i != indexPath.row) {
        
        
        MusicModel *model = [[MusicModel alloc]init];
        
        self.SingVC.i = indexPath.row;
        
        model = [self.listArray objectAtIndex:self.SingVC.i];
        
        self.SingVC.lrcAll = [[NSMutableArray alloc]init];
        self.SingVC.lrcTime = [[NSMutableArray alloc]init];
        self.SingVC.navigationItem.title = model.name;
        
        [self.SingVC.imageViewSceond sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
        self.SingVC.player = [[AVAudioPlayer alloc]init];
        [self.SingVC musicplay:model.mp3Url];
        
        [self.SingVC creatLrc:model.lyric];
        
        [self.SingVC creatPicture:model.picUrl];
        
    }
    
    
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    CGFloat point = M_PI_4;
    
    
    ani.values = @[@(9 * point),@(8 * point),@(7 * point),@(6 * point),@(5 * point),@(4 * point),@(3 * point),@(2 * point),@(point)];
    
    ani.repeatCount = MAXFLOAT;
    
    ani.duration = 5;
    
    [self.SingVC.picImageView.layer addAnimation:ani forKey:nil];
    
    
    [self.SingVC.picImageView.layer setMasksToBounds:YES];
    
    [self.SingVC.tableView reloadData];
    self.SingVC.i = indexPath.row;
    [self.navigationController pushViewController:self.SingVC animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


@end
