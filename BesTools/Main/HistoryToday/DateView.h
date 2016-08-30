//
//  DateView.h
//  MarKet
//
//  Created by dayu on 16/3/11.
//  Copyright © 2016年 Secret. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface DateView : UIView
@property (strong,nonatomic) UILabel *weekDayLabel;
@property (strong,nonatomic) UILabel *dayLabel;
- (id)initWithFrame:(CGRect)frame calendarItemSize:(CGSize)size;
@end