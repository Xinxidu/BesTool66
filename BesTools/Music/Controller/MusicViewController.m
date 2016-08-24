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
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
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
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"musicBG.jpeg"]];
    
    imageView.alpha = 0.8;
    
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
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[TableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    }
    [cell setModel:model];//刷新cell
    
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *selectedBGView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 110)];
    selectedBGView.layer.cornerRadius = 5;
    selectedBGView.backgroundColor=[UIColor colorWithRed:149/255.0 green:171/255.0 blue:192/255.0 alpha:0.6];
    [view addSubview:selectedBGView];
    UIImageView *diskView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cd_cover"]];
    diskView.frame=CGRectMake(0.8*WIDTH, 35, 40, 40);
    diskView.layer.cornerRadius=20;
    diskView.layer.masksToBounds=YES;
    [selectedBGView addSubview:diskView];
    
    // 1.创建基本动画
    CABasicAnimation *rotationAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 2.给动画设置一些属性
    rotationAnim.fromValue = @(0);
    rotationAnim.toValue = @(M_PI * 2);
    rotationAnim.repeatCount = NSIntegerMax;
    rotationAnim.duration = 35;
    [diskView.layer addAnimation:rotationAnim forKey:nil];
    // 3.将动画添加到iconView的layer上面
    cell.selectedBackgroundView = view;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

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
        
        [self.SingVC createLrc:model.lyric];
        
        [self.SingVC createPicture:model.picUrl];
        
    }
    
    
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    CGFloat point = M_PI_4;
    ani.values = @[@(9 * point),@(8 * point),@(7 * point),@(6 * point),@(5 * point),@(4 * point),@(3 * point),@(2 * point),@(point)];
    ani.repeatCount = MAXFLOAT;
    ani.duration = 5;
    [self.SingVC.picImageView.layer addAnimation:ani forKey:nil];
    [self.SingVC.picImageView.layer setMasksToBounds:YES];
    [self.SingVC.lrcTableView reloadData];
    [self.SingVC.bigLrcTableView reloadData];
    self.SingVC.i = indexPath.row;
    [self.navigationController pushViewController:self.SingVC animated:YES];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}


@end
