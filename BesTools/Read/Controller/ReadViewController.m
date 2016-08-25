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
@property (strong,nonatomic) BaseTableView *tableView;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic,assign)int page;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    _dataArray = [[NSMutableArray alloc]init];
    _page = 1;
    [self createReadTableView];

}
-(void)createReadTableView{
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
//    [self readTableViewRequest];
    __weak ReadViewController* blockSelf = self;
    [_tableView setRequestData:^{
        [blockSelf readTableViewRequest:NO];
    }];
    [_tableView setUpToLoadMore:^{
        [blockSelf readTableViewRequest:YES];
    }];
}
-(void)readTableViewRequest:(BOOL)isUp{
    if (isUp == YES) {
        _page++;
    }else{
        _page = 1;
    }
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //http://api.avatardata.cn/QiWenNews/Query?key=176bac8fb44a47b1bfe07a964a2d4e5b&page=1&rows=10
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.avatardata.cn/QiWenNews/Query?key=176bac8fb44a47b1bfe07a964a2d4e5b&page=%d&rows=10",_page]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [_tableView endrefresh];
        } else {
            if (isUp == YES) {
                
            }else{
                [_dataArray removeAllObjects];
            }
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
            [_tableView endrefresh];
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
