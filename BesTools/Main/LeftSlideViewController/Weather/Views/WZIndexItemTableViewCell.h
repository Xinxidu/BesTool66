//
//  WZIndexTableViewCell.h
//  Temperature
//
//  Created by 张武星 on 15/5/19.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZIndexItemTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *indexPicImageView;
@property (weak, nonatomic) IBOutlet UILabel *indexTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexDegreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *indexDescLabel;

@end
