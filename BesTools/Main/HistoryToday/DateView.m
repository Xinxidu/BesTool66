//
//  DateView.m
//  MarKet
//
//  Created by dayu on 16/3/11.
//  Copyright © 2016年 Secret. All rights reserved.
//
#import "DateView.h"
#define GOLD [UIColor colorWithRed:195/255.0 green:150/255.0 blue:69/255.0 alpha:1.0]
@implementation DateView
- (id)initWithFrame:(CGRect)frame calendarItemSize:(CGSize)size{
    self = [super initWithFrame:frame];
    if (self) {
        self.weekDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width-1, size.height/2.0)];
        self.weekDayLabel.textAlignment = NSTextAlignmentCenter;
        self.weekDayLabel.textColor = GOLD;
        self.weekDayLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.weekDayLabel];
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, size.height/2.0, size.width-1, size.height/2.0)];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.textColor = GOLD;
        self.dayLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:self.dayLabel];
    }
    return self;
}
@end