//
//  BaseTableView.h
//  MarKet
//
//  Created by Secret Wang on 16/3/24.
//  Copyright © 2016年 Secret. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface BaseTableView : UITableView
@property(copy,nonatomic)void(^requestData)();
@property(copy,nonatomic)void(^upToLoadMore)();
-(void)endrefresh;
@end