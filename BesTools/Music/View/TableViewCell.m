//
//  TableViewCell.m
//  MusicPlayer
//
//  Created by dllo on 16/1/24.
//  Copyright © 2016年 dllo. All rights reserved.
//

#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
@implementation TableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self createCell];
    }
    return self;
    
    
}
- (void)createCell{
    self.backgroundColor = [UIColor clearColor];
    self.imageViewPic = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 88, 88)];
    self.imageViewPic.layer.cornerRadius = 15;
    self.imageViewPic.layer.masksToBounds = YES;
    self.label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageViewPic.frame)+10, 10, 188, 60)];
    self.label.numberOfLines = 0;
    self.deqLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.imageViewPic.frame)+10, CGRectGetMaxY(self.label.frame)+5, 188, 20)];
    self.label.textColor = [UIColor blackColor];
    self.deqLabel.textColor = [UIColor grayColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.deqLabel.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:20];
    self.deqLabel.font=[UIFont systemFontOfSize:18.0];
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.deqLabel];
    [self.contentView addSubview:self.imageViewPic];
    
}

- (void)setModel:(MusicModel *)model{
    
    [self.imageViewPic sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.picUrl]] placeholderImage:[UIImage imageNamed:@"iconfont-yutoubaoicon.png"]];
    self.label.text = model.name;
    self.deqLabel.text = model.singer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
