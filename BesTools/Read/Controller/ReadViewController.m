//
//  ReadViewController.m
//  BesTools
//
//  Created by Aaron Lee on 16/8/18.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "ReadViewController.h"
#import <AFNetworking.h>
#import "ReadListModel.h"
#import "ReadTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "ReadDetailViewController.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@interface ReadViewController ()<UIWebViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UIWebView *readWebView;
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic,strong)UIActivityIndicatorView *activity;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    _dataArray = [[NSMutableArray alloc]init];
    [self createReadWebView];
    [self readWebViewRequest];
    _activity = [[UIActivityIndicatorView alloc]init];
    [_activity setCenter:self.view.center];
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    _activity.color = [UIColor redColor];
    [self.view addSubview:_activity];
    [_activity startAnimating];

}
-(void)createReadWebView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
-(void)readWebViewRequest{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://api.avatardata.cn/QiWenNews/Query?key=176bac8fb44a47b1bfe07a964a2d4e5b&page=1&rows=10"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
//            NSLog(@"%@ %@", response, responseObject);
            NSArray *array = responseObject[@"result"];
            for (NSDictionary *dict in array) {
                ReadListModel *model = [[ReadListModel alloc]init];
                model.Description = dict[@"description"];
                model.title = dict[@"title"];
                model.ctime = dict[@"ctime"];
                model.picUrl = dict[@"picUrl"];
                model.detailurl = dict[@"url"];
                [_dataArray addObject:model];
                
            }
            [_tableView reloadData];
        }
    }];
    [dataTask resume];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;

}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    ReadTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
        {
            cell = [[ReadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
    ReadListModel *model = _dataArray[indexPath.row];
    cell.ctimeLabel.text = model.ctime;
    cell.DescriptionLabel.text = model.Description;
    cell.titleLabel.text = model.title;
    [cell.picUrlImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:nil];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中了%ld",indexPath.row);
    ReadDetailViewController *detail = [[ReadDetailViewController alloc]init];
    ReadListModel *model = _dataArray[indexPath.row];
    detail.url = model.detailurl;
    [self.navigationController pushViewController:detail animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}
//判断tabview是否加载到最后一行，停止刷新
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if([indexPath row] == ((NSIndexPath*)[[tableView indexPathsForVisibleRows] lastObject]).row){
        [_activity stopAnimating];//停止刷新
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
