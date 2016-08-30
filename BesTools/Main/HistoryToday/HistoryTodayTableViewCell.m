//
//  HistoryTodayTableViewCell.m
//  BesTools
//
//  Created by pan on 16/8/29.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "HistoryTodayTableViewCell.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation HistoryTodayTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}
-(void)createView{
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 60)];
    _dateLabel.textColor = [UIColor colorWithRed:187/255.0 green:43/255.0 blue:47/255.0 alpha:1.0];
    _dateLabel.font = [UIFont systemFontOfSize:15.0];
    _dateLabel.layer.cornerRadius = 30.0;
    _dateLabel.clipsToBounds = YES;
    _dateLabel.backgroundColor = [UIColor redColor];
    _dateLabel.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    _dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_dateLabel];
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(_dateLabel.frame), 1, 80-60)];
    _lineLabel.backgroundColor = [UIColor colorWithRed:195/255.0 green:150/255.0 blue:69/255.0 alpha:1.0];
    [self.contentView addSubview:_lineLabel];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_dateLabel.frame)+10, 5, WIDTH-CGRectGetMaxX(_dateLabel.frame)-20, 60)];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
//    _titleLabel.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];;
    [self.contentView addSubview:_titleLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
