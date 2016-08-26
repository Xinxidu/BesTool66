//
//  BaseTableView.m
//  MarKet
//
//  Created by Secret Wang on 16/3/24.
//  Copyright © 2016年 Secret. All rights reserved.
//
#import "BaseTableView.h"
#import "MJRefresh.h"

@implementation BaseTableView
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self createView];
    }
    return self;
}
-(void)createView{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (_requestData) {
            self.requestData();
        }
    }];
    [self.mj_header beginRefreshing];
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_upToLoadMore) {
            self.upToLoadMore();
        }
    }];
}
-(void)endrefresh{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}
@end