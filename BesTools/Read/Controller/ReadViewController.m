//
//  ReadViewController.m
//  BesTools
//
//  Created by Aaron Lee on 16/8/18.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "ReadViewController.h"

@interface ReadViewController ()<UIWebViewDelegate>
@property (strong,nonatomic) UIWebView *readWebView;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor grayColor];
    [self createReadWebView];
    [self readWebViewRequest];
}
-(void)createReadWebView{
//    _readWebView = [[UIWebView alloc]init];
//    _readWebView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
//    _readWebView.delegate = self;
//    _readWebView.scrollView.bounces = NO;
//    [self.view addSubview:_readWebView];
    
}
-(void)readWebViewRequest{
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://k.sogou.com/abs/ios/v3/girl?gender=1"]];
//    [_readWebView loadRequest:request];
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
