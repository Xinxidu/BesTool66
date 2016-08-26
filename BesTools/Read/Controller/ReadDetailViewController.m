//
//  ReadDetailViewController.m
//  BesTools
//
//  Created by pan on 16/8/24.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "ReadDetailViewController.h"

@interface ReadDetailViewController ()<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UIActivityIndicatorView *activity;
@end

@implementation ReadDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"猎奇奇闻";
    [self createWebView];
    [self requestData];
    //刷新控件
    _activity = [[UIActivityIndicatorView alloc]init];
    [_activity setCenter:self.view.center];
    [_activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    _activity.color = [UIColor redColor];
    [self.view addSubview:_activity];
    [_activity startAnimating];
}
-(void)createWebView{
    _webView = [[UIWebView alloc]init];
    _webView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    _webView.delegate = self;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
}
-(void)requestData{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
//    [_activity stopAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activity stopAnimating];
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
