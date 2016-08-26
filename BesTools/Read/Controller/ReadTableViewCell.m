//
//  ReadTableViewCell.m
//  BesTools
//
//  Created by pan on 16/8/24.
//  Copyright © 2016年 Aaron Lee. All rights reserved.
//

#import "ReadTableViewCell.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
#define HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation ReadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor=[UIColor whiteColor];
        [self createView];
    }
    return self;
}
-(void)createView{
    //图片
    _picUrlImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 120, 80)];
    [self.contentView addSubview:_picUrlImageView];
    //title
    _titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+120+10, 5, WIDTH-(10+120+10+10), 36)];
    _titleLabel.font=[UIFont systemFontOfSize:15.0];
    _titleLabel.text=@"lallalalalla";
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.numberOfLines = 0;
    _titleLabel.textColor=[UIColor blackColor];
    [self.contentView addSubview:_titleLabel];
    //时间ctime
    _ctimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10+120+10, 5+36+10+20, 200, 12)];
    _ctimeLabel.font=[UIFont systemFontOfSize:12.0];
    _ctimeLabel.text=@"lallalalalla";
    _ctimeLabel.textColor=[UIColor grayColor];
    [self.contentView addSubview:_ctimeLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
