//
//  HistoyrTodayViewController.m
//  BesTools
//
//  Created by pan on 16/8/29.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "HistoyrTodayViewController.h"
#import "DateView.h"
#import "BaseTableView.h"
#import <AFNetworking.h>
#import "HistoryTodayModel.h"
#import "HistoryTodayTableViewCell.h"
#import "HistoryDetailViewController.h"

#define HEIGHT CGRectGetHeight(self.view.bounds)
#define WIDTH CGRectGetWidth(self.view.bounds)
#define CALENDARBUTTONWIDTH 60
#define CALENDARBUTTONHEIGHT 44
#define CALENDARITEMWIDTH (WIDTH-CALENDARBUTTONWIDTH*2)/5.0-1
#define GOLD [UIColor colorWithRed:195/255.0 green:150/255.0 blue:69/255.0 alpha:1.0]
#define GRAY [UIColor colorWithRed:230/255.0 green:229/255.0 blue:227/255.0 alpha:1.0]
@interface HistoyrTodayViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (strong,nonatomic) UIScrollView *dateScrollView;//日期选项卡
@property (strong,nonatomic) NSMutableArray *dayArray;//日期数组
@property (strong,nonatomic) NSMutableArray *weekArray;//星期数组
@property (strong,nonatomic) NSMutableArray *viewArray;//日期View数组
@property (strong,nonatomic) UIAlertController *calendarAlert;//日期弹窗
@property (strong,nonatomic) NSDate *selectedDate;//选中日期
//@property (strong,nonatomic) UITableView *tableView;//表格
@property (strong,nonatomic) UIAlertController *dateAlert;//自定义日历控制器弹窗
@property (strong,nonatomic) BaseTableView *tableView;
@property (strong,nonatomic) NSMutableArray *HistorydataArray;
@property (nonatomic,assign)int page;
@property (nonatomic,strong)NSString *dateString;//月份字符串
@property (nonatomic,strong)UIButton *dateButton;//右侧日期按钮
@property (nonatomic,strong)NSString *urlString;//接口字符串，月日：8/29
@end

@implementation HistoyrTodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史上的今天";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.viewArray = [NSMutableArray array];
    //日历按钮
    UIButton *calendarButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, CALENDARBUTTONWIDTH-1, CALENDARBUTTONHEIGHT)];
    calendarButton.backgroundColor = GRAY;
    [calendarButton setImage:[UIImage imageNamed:@"calendar"] forState:UIControlStateNormal];
    [calendarButton addTarget:self action:@selector(calendarClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:calendarButton];
    //获取本月的"日"和星期数组
    self.dayArray = [self getDayArrayFromDate:[NSDate date]];
    self.weekArray = [self getWeekArrayFromDate:[NSDate date]];
    //创建日期选项卡 UIScrollView
    [self createScrollViewWithDate:[NSDate date]];
    //右侧日期按钮
    //默认当月月份
    NSDateComponents *components = [self getDateComponents:[NSDate date]];
    NSInteger month = [components month];
    NSInteger day = [components day];
    _urlString = [NSString stringWithFormat:@"%ld/%ld",month,day];
    _dateString = [NSString stringWithFormat:@"%ld",month];
    _dateButton = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH-CALENDARBUTTONWIDTH+1, 64, CALENDARBUTTONWIDTH-1, CALENDARBUTTONHEIGHT)];
    _dateButton.backgroundColor = GOLD;
    [_dateButton setTitle:[NSString stringWithFormat:@"%@月",_dateString] forState:UIControlStateNormal];
    [_dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _dateButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _dateButton.backgroundColor = GOLD;
    [self.view addSubview:_dateButton];
    _HistorydataArray = [[NSMutableArray alloc]init];
    _page = 1;
    [self createTableView];//初始化表格视图
    [self initCustomAlert];//初始化自定义弹窗
    
}
#pragma mark 初始化自定义弹窗
- (void)initCustomAlert{
    if (_dateAlert == nil) {
        _dateAlert = [UIAlertController alertControllerWithTitle:@"请选择日期" message:@"\n\n\n\n\n\n\n\n"  preferredStyle:UIAlertControllerStyleAlert];
        //添加日历控件
        UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, 270, 150)];
        datePicker.datePickerMode = UIDatePickerModeDate;
        [datePicker setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
        datePicker.timeZone = [NSTimeZone timeZoneWithName:@"Asia/beijing"];
        if (self.selectedDate!=nil) {
            [datePicker setDate:self.selectedDate animated:YES];
        }
        [_dateAlert.view addSubview:datePicker];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self sureActionForDatePicker:[datePicker date]];
        }];
        [_dateAlert addAction:sureAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [_dateAlert addAction:cancelAction];
    }
}
#pragma mark 初始化表格
- (void)createTableView{
    _tableView=[[BaseTableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dateScrollView.frame), WIDTH, HEIGHT-_dateScrollView.frame.size.height-64) style:UITableViewStylePlain];
//    _tableView.backgroundColor=[UIColor colorWithRed:243/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.bounces=YES;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorColor=[UIColor grayColor];
    [self.view addSubview:_tableView];
    __weak HistoyrTodayViewController* blockSelf = self;
    [_tableView setRequestData:^{
        [blockSelf readTableViewRequest:NO];
    }];
//    [_tableView setUpToLoadMore:^{
//        [blockSelf readTableViewRequest:YES];
//    }];
#pragma mark 请求数据列表
}
-(void)readTableViewRequest:(BOOL)isUp{
    NSLog(@"调用了,%@",_urlString);
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //http://api.avatardata.cn/QiWenNews/Query?key=176bac8fb44a47b1bfe07a964a2d4e5b&page=1&rows=10
//    NSURL *URL = [NSURL URLWithString:@"http://v.juhe.cn/todayOnhistory/queryEvent.php?key=21f06eaaeea1c6387a508f4851cfaa37&date=8/29"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://v.juhe.cn/todayOnhistory/queryEvent.php?key=21f06eaaeea1c6387a508f4851cfaa37&date=%@",_urlString]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [_tableView endrefresh];
        } else {
            if (isUp == YES) {
                
            }else{
                [_HistorydataArray removeAllObjects];
            }
            //            NSLog(@"%@ %@", response, responseObject);
            NSArray *array = responseObject[@"result"];
            for (NSDictionary *dict in array) {
                HistoryTodayModel *model = [[HistoryTodayModel alloc]init];
                NSArray* array = [dict[@"date"] componentsSeparatedByString:@"年"];
                model.date = array[0];
                model.title = dict[@"title"];
                model.e_id = dict[@"e_id"];
                [_HistorydataArray addObject:model];
//                NSLog(@"%@",dict);
            }
            [_tableView reloadData];
            [_tableView endrefresh];
        }
    }];
    [dataTask resume];
    
}
#pragma mark tableView的代理返回cell高度和个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _HistorydataArray.count;
}
#pragma mark tableView的代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellId = @"cell";
    HistoryTodayTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell=[[HistoryTodayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    HistoryTodayModel *model = _HistorydataArray[indexPath.row];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@年",model.date];
    cell.titleLabel.text = model.title;
    cell.dateLabel.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HistoryDetailViewController *detail = [[HistoryDetailViewController alloc]init];
    HistoryTodayModel *model = _HistorydataArray[indexPath.row];
    detail.ID = model.e_id;
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma mark 日历按钮点击事件
- (void)calendarClick:(UIButton *)sender{
    [self presentViewController:_dateAlert animated:YES completion:nil];
}

#pragma mark 点击日历控件"确定"事件
- (void)sureActionForDatePicker:(NSDate *)date{
    //根据日历控件选中的日期重新加载日期选项卡
    [self.dayArray removeAllObjects];
    [self.weekArray removeAllObjects];
    for (DateView *aView in self.dateScrollView.subviews) {
        [aView removeFromSuperview];
    }
    [self.viewArray removeAllObjects];
    self.dayArray = [self getDayArrayFromDate:date];
    self.weekArray = [self getWeekArrayFromDate:date];
    [self createScrollViewWithDate:date];
    self.selectedDate = date;
    NSDateComponents *components = [self getDateComponents:_selectedDate];
    NSInteger month = [components month];
    NSInteger day = [components day];
    _dateString = [NSString stringWithFormat:@"%ld",month];
    _urlString = [NSString stringWithFormat:@"%ld/%ld",month,day];
    [_dateButton setTitle:[NSString stringWithFormat:@"%@月",_dateString] forState:UIControlStateNormal];
    [self readTableViewRequest:NO];
    
}

#pragma mark 获取指定日期的NSDateComponents对象
- (NSDateComponents *)getDateComponents:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    return components;
}
#pragma mark 获取指定日期所对应的当月天数
- (NSInteger)getDaysFromDate:(NSDate *)date{
    NSDateComponents *components = [self getDateComponents:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    switch (month) {
        case 2:
            return ((year%4==0&&year%100!=0)||year%400==0) ? 29 : 28;   break;
        case 4: case 6: case 9: case 11:
            return 30;  break;
        default:
            return 31;  break;
    }
}
- (NSMutableArray *)getDayArrayFromDate:(NSDate *)date{
    NSInteger  daysOfMonth = [self getDaysFromDate:date];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1 ; i <= daysOfMonth; i++ ) {
        [array addObject:[NSString stringWithFormat:@"%d",i]];
    }
    return array;
}
#pragma mark 获取本月的星期数组
- (NSMutableArray *)getWeekArrayFromDate:(NSDate *)date{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = 1;
    components.month = [[self getDateComponents:date] month];
    components.year = [[self getDateComponents:date] year];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *calendarDate = [calendar dateFromComponents:components];
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:calendarDate];
    NSInteger firstWeekDayOfCurrentMonth = [weekdayComponents weekday]-1;
    NSArray *weekDayArray = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSMutableArray *array = [NSMutableArray array];
    for (int i =1 ; i<= self.dayArray.count; i++) {
        int weekDay = (firstWeekDayOfCurrentMonth + (i-1))%7;
        [array addObject:[weekDayArray objectAtIndex:weekDay]];
    }
    return array;
}

#pragma mark 创建日期选项卡
- (void)createScrollViewWithDate:(NSDate *)date{
    if (self.dateScrollView!=nil) {
        [self.dateScrollView removeFromSuperview];
        self.dateScrollView = nil;
    }
    self.dateScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CALENDARBUTTONWIDTH, 64, WIDTH-CALENDARBUTTONWIDTH*2, CALENDARBUTTONHEIGHT)];
    self.dateScrollView.contentSize = CGSizeMake((CALENDARITEMWIDTH+1)*self.dayArray.count, 40);
    self.dateScrollView.backgroundColor = [UIColor whiteColor];
    self.dateScrollView.showsHorizontalScrollIndicator = NO;
    self.dateScrollView.delegate = self;
    self.dateScrollView.bounces = NO;
    [self.view addSubview:self.dateScrollView];
    for (int i = 0; i< self.dayArray.count; i++) {
        DateView *aView = [[DateView alloc] initWithFrame:CGRectMake(1+i*(CALENDARITEMWIDTH+1), 0, CALENDARITEMWIDTH, CALENDARBUTTONHEIGHT) calendarItemSize:CGSizeMake(CALENDARITEMWIDTH, CALENDARBUTTONHEIGHT)];
        aView.backgroundColor = GRAY;
        aView.tag = i+1;
        [self.dateScrollView addSubview:aView];
        aView.weekDayLabel.text = [self.weekArray objectAtIndex:i];
        aView.dayLabel.text = [self.dayArray objectAtIndex:i];
        //添加点击事件让UIView能点击
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClick:)];
        [aView addGestureRecognizer:tapGesture];
        [self.viewArray addObject:aView];
    }
    //默认当天被选中
    NSDateComponents *components = [self getDateComponents:date];
    NSInteger day = [components day];
    DateView *currentView = (DateView *)[self.viewArray objectAtIndex:day-1];
    currentView.backgroundColor = GOLD;
    currentView.weekDayLabel.textColor = [UIColor whiteColor];
    currentView.dayLabel.textColor = [UIColor whiteColor];
    if (day>3&&day<self.self.dayArray.count-3) {
        self.dateScrollView.contentOffset = CGPointMake(1+(day -3)*(CALENDARITEMWIDTH+1), 0);
    }else if (day<=3) {
        self.dateScrollView.contentOffset = CGPointMake(1, 0);
    }else {
        self.dateScrollView.contentOffset = CGPointMake(1+(self.dayArray.count-5)*(CALENDARITEMWIDTH+1), 0);
    }
}

#pragma mark 日历选项卡点击事件
- (void)viewClick:(UITapGestureRecognizer *)sender{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    for (DateView *aView in self.viewArray) {
        aView.backgroundColor = GRAY;
        aView.weekDayLabel.textColor = GOLD;
        aView.dayLabel.textColor = GOLD;
        NSString *arrayObject = aView.dayLabel.text;
        [array addObject:arrayObject];
    }
    DateView *aView= (DateView *)sender.view;
    aView.backgroundColor = GOLD;
    aView.weekDayLabel.textColor = [UIColor whiteColor];
    aView.dayLabel.textColor = [UIColor whiteColor];
    //让选中的View居中
    if ((self.dateScrollView.contentOffset.x>1&&self.dateScrollView.contentOffset.x<1+(self.dayArray.count-5)*(CALENDARITEMWIDTH+1))||sender.view.tag ==4||sender.view.tag ==5 || sender.view.tag ==self.dayArray.count-4||sender.view.tag == self.dayArray.count-3) {
        [self.dateScrollView setContentOffset:CGPointMake(1+(sender.view.tag -3)*(CALENDARITEMWIDTH+1), 0) animated:YES];
    }
    //拼接需要的URL字符串格式：如8/29
    NSString *str = array[aView.tag-1];
    _urlString = [NSString stringWithFormat:@"%@/%@",_dateString,str];
    [self readTableViewRequest:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //防止UIScrollView往最左边或最右边偏移时出界
    if (self.dateScrollView.contentOffset.x<1){
        [self.dateScrollView setContentOffset:CGPointMake(1, 0)];
    }else if (self.dateScrollView.contentOffset.x>1+(self.dayArray.count-5)*(CALENDARITEMWIDTH+1)){
        [self.dateScrollView setContentOffset:CGPointMake(1+(self.dayArray.count-5)*(CALENDARITEMWIDTH+1), 0)];
    }
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
