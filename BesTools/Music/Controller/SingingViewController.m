//
//  SingingViewController.m
//  MusicPlayer
//
//  Created by dllo on 16/1/22.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "SingingViewController.h"
#import "UIImageView+WebCache.h"
//#import "ViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SingingViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>

@property (nonatomic, retain) NSTimer *timer;
@property (strong,nonatomic) UIButton *previousBtn;
@end

@implementation SingingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    同时显示left 和 back item
//    ViewController *root = [[ViewController alloc]init];
//    root.deleGate = self;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.lrcAll = [[NSMutableArray alloc]init];
    self.lrcTime = [[NSMutableArray alloc]init];
    self.playOrPause = NO;
    self.lycYesOrNo = NO;
    [self createPage];
    //创建歌词
    [self createTableView];
    //创建大页面歌词
    [self createBigTableView];
    //创建播放按钮
    [self createBtn];
    //创建时间进度条
    [self createSlider];
    //音量
   // [self volume];
    //导航栏右侧歌词开关
    [self lrcShow];
    [self createSegment];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    UIImageView *image = (UIImageView *)[self.tabBarController.view viewWithTag:100];
    image.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    UIImageView *image = (UIImageView *)[self.tabBarController.view viewWithTag:100];
    image.hidden = NO;
}
//导航栏右侧歌词开关
-(void)lrcShow{
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0,0,30,30)];
    
    [rightBtn setImage:[UIImage imageNamed:@"geci"]forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(btnR) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//-(void)back:(id)sender{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//铺页面
- (void)createPage{
    MusicModel *model = [[MusicModel alloc]init];
    model = [self takeModel];
//    调用背景
    [self createScrollViewBack];
    [self createScrollLeftView];
    [self createScrollRightView:model.blurPicUrl];
//    调用光盘方法
    self.picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    [self createPicture:model.picUrl];
//调用播放器
//    [self musicplay:model.mp3Url];
 // 歌名 navgationBar 标题
    self.navigationItem.title = model.name;
//   调用歌词
    [self createLrc:model.lyric];
    
}
//把传过来的model解析
- (MusicModel *)takeModel{
    
    MusicModel *model = [[MusicModel alloc]init];
    
    model = [self.listArray objectAtIndex:self.i];
    
    return model;
}
//歌词
- (void)createLrc:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    
    for (int i = 0; i < [array count]; i++) {
        
        NSString *lineString = [array objectAtIndex:i];
        
        NSArray *lineArray = [lineString componentsSeparatedByString:@"]"];
        
        if ([lineArray[0] length] > 8) {
            
            NSString *str1 = [lineString substringWithRange:NSMakeRange(3, 1)];
            
            NSString *str2 = [lineString substringWithRange:NSMakeRange(6, 1)];
            
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                
                for (int i = 0; i < lineArray.count - 1; i++) {
                    
                    NSString *lrcString = [lineArray objectAtIndex:lineArray.count - 1];
                    
                    //分割区间求歌词时间
                    NSString *timeString = [[lineArray objectAtIndex:i] substringWithRange:NSMakeRange(1, 5)];
                    
                    //把时间 和 歌词 加入
                    [self.lrcTime addObject:timeString];
                    [self.lrcAll addObject:lrcString];
                    
                }
            }
        }
    }
 
}

- (void)time{
    int hh= 0,mm = 0,ss = 0;
    NSString *mmStr= nil;
    NSString *ssStr= nil;
    hh = self.player.currentTime / 360;
    mm = (self.player.currentTime -hh * 360)/ 60;
    ss = (int)self.player.currentTime % 60;
    if (mm< 10){
        
        mmStr= [NSString stringWithFormat:@"0%d",mm];
        
    } else {
        
        mmStr= [NSString stringWithFormat:@"%d",mm];
        
    }
    if (ss< 10){
        
        ssStr= [NSString stringWithFormat:@"0%d",ss];
        
    } else {
        
        ssStr= [NSString stringWithFormat:@"%d",ss];
        
    }
        NSString *currTime0 = [mmStr stringByAppendingString:@":"];
        self.currTime = [currTime0 stringByAppendingString:ssStr];
        if (self.lrcTime != nil&&self.lrcAll != nil) {
            for (int i = 0; i < self.lrcTime.count; i++) {
             
                if ([self.lrcTime[i] isEqualToString:self.currTime]) {
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    
                    [self.lrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                    [self.bigLrcTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                }
            }
        }

    }
//音乐播放器

- (void)musicplay:(NSString *)str{

//    播放器运行
    NSString *urlStr = [NSString stringWithFormat:@"%@",str];
    
    NSURL *url = [[NSURL alloc]initWithString:urlStr];
    
    NSData * audioData = [NSData dataWithContentsOfURL:url];
    //将数据保存到本地指定位置
//    NSString *docDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *filePath = [NSString stringWithFormat:@"%@/%@.mp3", docDirPath , @"temp"];
//    [audioData writeToFile:filePath atomically:YES];
//    NSLog(@"%@",filePath);
//    //播放本地音乐
//    NSURL *fileURL = [NSURL fileURLWithPath:filePath];
//    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    
    self.player = [[AVAudioPlayer alloc]initWithData:audioData error:nil];
    [self.player prepareToPlay];
    self.player.delegate = self;
    self.player.volume = 3;//默认音量
    [self.player play];

}

//按钮
- (void)createBtn{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5, HEIGHT-88, WIDTH-10, 68)];
    view.alpha = 0.6;
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [[UIColor blackColor]CGColor];
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 15;
//    按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(10, 18, 30, 30);
    [btn1 setBackgroundImage:[UIImage imageNamed:@"redo"] forState:UIControlStateNormal];
    self.previousBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.previousBtn.frame = CGRectMake(CGRectGetMaxX(btn1.frame)+15, 15, 35, 35);
     [self.previousBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-bofangqishangyiqu"] forState:UIControlStateNormal];
    self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn3.frame = CGRectMake(CGRectGetMaxX(self.previousBtn.frame)+WIDTH*0.22, 15, 35, 35);
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
    
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(CGRectGetMaxX(self.btn3.frame)+WIDTH*0.22, 15, 35, 35);
    [btn4 setBackgroundImage:[UIImage imageNamed:@"iconfont-bofangqixiayiqu"] forState:UIControlStateNormal];
//    给按钮添加事件
//    播放
    [self.btn3 addTarget:self action:@selector(go) forControlEvents:UIControlEventTouchUpInside];
    [self.previousBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [btn4 addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
//    [btn1 addTarget:self action:@selector(too) forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:btn1];
     [view addSubview:self.previousBtn];
     [view addSubview:self.btn3];
     [view addSubview:btn4];
//     UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [self.view addSubview:view];
    
}

//时间进度
-(void)createSlider{
    self.slider = [[UISlider alloc]initWithFrame:CGRectMake(30, HEIGHT-128, WIDTH-60, 10)];
    self.slider.thumbTintColor = [UIColor blueColor];
    self.slider.maximumValue = self.player.duration;
    self.slider.minimumValue = 0;
    [self.view addSubview:self.slider];
    [self.slider addTarget:self action:@selector(slider:) forControlEvents:UIControlEventTouchUpInside];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(timerTake) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)timerTake{
    self.slider.value = self.player.currentTime;
    [self time];
}
- (void)go{
    if (self.playOrPause == YES) {
           [self.player play];
        self.playOrPause = NO;
        [self.btn3 setBackgroundImage:[UIImage imageNamed:@"iconfont-zanting"] forState:UIControlStateNormal];
    }else{
        [self.player pause];
        self.playOrPause = YES;
           [self.btn3 setBackgroundImage:[UIImage imageNamed:@"iconfont-bofangqibofang"] forState:UIControlStateNormal];
    }
    
}
- (void)next{
    //NSLog(@"下一首");
    self.i = self.i + 1;
    MusicModel *model = [[MusicModel alloc]init];
    model = [self takeModel];
    self.lrcAll = [[NSMutableArray alloc]init];
    self.lrcTime = [[NSMutableArray alloc]init];
    self.navigationItem.title = model.name;
    [self.imageViewSceond sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    [self musicplay:model.mp3Url];
    [self createLrc:model.lyric];
    [self.lrcTableView reloadData];
    [self.bigLrcTableView reloadData];
    self.previousBtn.enabled=YES;
}
- (void)back{
    if (self.i==0) {
        self.previousBtn.enabled=NO;
    }else{
        self.i = self.i - 1;
        MusicModel *model = [[MusicModel alloc]init];
        model = [self takeModel];
        self.lrcAll = [[NSMutableArray alloc]init];
        self.lrcTime = [[NSMutableArray alloc]init];
        self.navigationItem.title = model.name;
        [self.imageViewSceond sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
        [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
        [self musicplay:model.mp3Url];
        [self createLrc:model.lyric];
        [self.lrcTableView reloadData];
        [self.bigLrcTableView reloadData];
        self.previousBtn.enabled=YES;
    }
}
//需要修改
//- (void)too{
//    //NSLog(@"再听一遍");
//    [self back];
//    [self next];    
//}
//slider触发事件
- (void)slider:(UISlider *)slider{
    
    [self.timer setFireDate:[NSDate distantFuture]];
    self.player.currentTime = slider.value;
    NSTimer *timerOnce = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerOnce) userInfo:nil repeats:NO];
    [timerOnce fire];
    
}
- (void)timerOnce{
    [self.timer setFireDate:[NSDate distantPast]];
    
}
//铺tableView 在ScrollView 上面
- (void)createTableView{

    self.lrcTableView = [[UITableView alloc]
    initWithFrame:CGRectMake(WIDTH + 30, CGRectGetMaxY(self.picImageView.frame)+10, WIDTH-60, 160)];
    self.lrcTableView.backgroundColor = [UIColor clearColor];
    self.lrcTableView.dataSource = self;
    self.lrcTableView.delegate = self;
    [self.scrollView addSubview:self.lrcTableView];
}
- (void)createBigTableView{
    self.bigLrcTableView = [[UITableView alloc]initWithFrame:CGRectMake(30, 58, WIDTH-60, 0.58*HEIGHT)];
    self.bigLrcTableView.backgroundColor = [UIColor clearColor];
    self.bigLrcTableView.dataSource=self;
    self.bigLrcTableView.delegate=self;
    [self.scrollView addSubview:self.bigLrcTableView];
}
//协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.lrcAll.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc]initWithStyle:1 reuseIdentifier:@"cell"];
    
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    cell.textLabel.text = [self.lrcAll objectAtIndex:indexPath.row];
        
//        NSLog(@"%@",[self.lrcAll objectAtIndex:indexPath.row]);
    
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
//    [cell.textLabel setNumberOfLines:0];
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    
    cell.textLabel.textColor = [UIColor cyanColor];
 
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置文字高亮颜色
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:0.2 green:0.3 blue:0.9 alpha:1];
    // 设置被选取的cell
    UIView *view = [[UIView alloc]initWithFrame:cell.contentView.frame];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
//光盘 music 里面调用
- (void)createPicture:(NSString *)str{
   
    self.picImageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width + WIDTH/2, 120);
    
    self.picImageView.layer.cornerRadius = 100;
    
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:str]];

    CAKeyframeAnimation *ani = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    
    CGFloat point = M_PI_4;
    
    ani.values = @[@(9 * point),@(8 * point),@(7 * point),@(6 * point),@(5 * point),@(4 * point),@(3 * point),@(2 * point),@(point)];
    ani.repeatCount = MAXFLOAT;
    
    ani.duration = 5;
    
    [self.picImageView.layer addAnimation:ani forKey:nil];
    
     [self.picImageView.layer setMasksToBounds:YES];
    
     [self.scrollView addSubview:self.picImageView];
    
}
//Scroll music 里面调用
- (void)createScrollViewBack{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    self.scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(WIDTH * 2, 0);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
}
- (void)createScrollLeftView{
    
    UIImageView *imageViewFirst = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 750)];
    //imageViewFirst.image = [UIImage imageNamed:@"bake.jpg"];
    [self.scrollView addSubview:imageViewFirst];
}
- (void)createScrollRightView:(NSString *)str{

    //播放背景图片
    self.imageViewSceond = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 750)];
    [self.imageViewSceond sd_setImageWithURL:[NSURL URLWithString:str]];
    //    毛玻璃
    //    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    //
    //    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    //
    //    effectView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 680);
    //
    //    effectView.alpha = 0.8;
    //
    //    [self.imageViewSceond addSubview:effectView];
    //    ----------
    [self.scrollView addSubview:self.imageViewSceond];

}

//歌词显示与关闭
- (void)btnR{
    if (self.lycYesOrNo == NO) {
        self.lrcTableView.alpha = 0;
        self.bigLrcTableView.alpha = 0;
        self.lycYesOrNo = YES;
        
    }else if (self.lycYesOrNo == YES){
        
        self.lrcTableView.alpha = 1;
        self.bigLrcTableView.alpha = 1;
        self.lycYesOrNo = NO;
    }
    
    
}

- (void)goBackClick{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.player stop];
}
//AV的协议方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self next];
}

//声道
- (void)createSegment{
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[@"左声道",@"立体声",@"右声道"]];
    segment.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 45);
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 1;
    segment.tintColor = [UIColor grayColor];
    [self.scrollView addSubview:segment];
}
- (void)segmentClick:(UISegmentedControl *)btn{
    if (btn.selectedSegmentIndex == 1) {
        self.player.pan = -1;
    }else if (btn.selectedSegmentIndex == 2){
        self.player.pan = 0;

    }else if (btn.selectedSegmentIndex == 3){
        self.player.pan = 1;

    }
}
//警告
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
//页面将要进入前台，开启定时器
//-(void)viewWillAppear:(BOOL)animated
//{
//    //开启定时器
//   [self.timer setFireDate:[NSDate distantPast]];
//}

////页面消失，进入后台不显示该页面，关闭定时器
//-(void)viewDidDisappear:(BOOL)animated
//{
//    //关闭定时器
//    [self.timer setFireDate:[NSDate distantFuture]];
//}
@end
