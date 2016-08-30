//
//  HistoryDetailViewController.m
//  BesTools
//
//  Created by pan on 16/8/30.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "HistoryDetailViewController.h"
#import <AFNetworking.h>
#import <UIImageView+WebCache.h>

@interface HistoryDetailViewController ()<UITextViewDelegate>
@property (nonatomic,strong)UILabel *titleLabel;
//@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UITextView *contentTextView;
//@property (nonatomic,strong)NSMutableArray *array;
//@property (nonatomic,strong)NSString *urlStr;
@end

@implementation HistoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self createView];
    [self requestData];
    NSLog(@"");
    
}
-(void)createView{
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 64, 300, 40)];
    _titleLabel.textColor = [UIColor redColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    [self.view addSubview:_titleLabel];
    
//    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+2, SCREEN_WIDTH-20, 300)];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:_urlStr] placeholderImage:nil];
//    [self.view addSubview:_imageView];
    
    _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame)+2, SCREEN_WIDTH-20, SCREEN_HEIGHT-100)];
    _contentTextView.textColor = [UIColor blackColor];
    _contentTextView.font = [UIFont fontWithName:@"Arial" size:14.0];
    _contentTextView.delegate = self;
    _contentTextView.scrollEnabled = YES;
    _contentTextView.editable = NO;
    _contentTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_contentTextView];
}
-(void)requestData{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http://v.juhe.cn/todayOnhistory/queryDetail.php?key=21f06eaaeea1c6387a508f4851cfaa37&e_id=%@",_ID]];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSArray *array = responseObject[@"result"];
            for (NSDictionary *dict in array) {
//                NSLog(@"%@",dict);
                _titleLabel.text = dict[@"title"];
                NSString *content = [dict[@"content"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                _contentTextView.text = content;
//                
//                NSArray *picarray = dict[@"picUrl"];
//                NSMutableArray *mutalArray = [[NSMutableArray array]init];
//                if (picarray.count>0) {//判断图片数组是否为空
//                    for (NSDictionary *di in picarray) {
//                        NSString *str = di[@"url"];
//                        
//                        [mutalArray addObject:str];
//                    }
//                }
//                NSLog(@"12345::%@",mutalArray[0]);
//                _urlStr = mutalArray[0];
//                [_imageView sd_setImageWithURL:[NSURL URLWithString:_urlStr] placeholderImage:nil];
            }
        }
    }];
    [dataTask resume];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
