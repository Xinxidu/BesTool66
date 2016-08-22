//
//  WZTitleTableViewCell.m
//  Weather
//
//  Created by 张武星 on 15/5/31.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZTitleTableViewCell.h"

@implementation WZTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)instance{
    WZTitleTableViewCell *cell;
    cell =   [[[NSBundle mainBundle] loadNibNamed:@"WZTitleTableViewCell" owner:self options:nil]lastObject];
    
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
