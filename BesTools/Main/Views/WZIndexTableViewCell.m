//
//  WZIndexTableViewCell.m
//  Weather
//
//  Created by 张武星 on 15/5/31.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZIndexTableViewCell.h"
#import "WZIndexItemTableViewCell.h"
#import "WZIndex.h"
#import "WZWeatherTool.h"
@implementation WZIndexTableViewCell

-(void)awakeFromNib{
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor clearColor];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)setWzIndex:(NSArray *)wzIndex{
    _wzIndex = wzIndex;
    [self.tableView reloadData];
}

+(instancetype)instance{
    WZIndexTableViewCell *cell;
    cell = [[[NSBundle mainBundle] loadNibNamed:@"WZIndexTableViewCell" owner:self options:nil]lastObject];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    return self.wzIndex.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WZIndexItemTableViewCell *itemCell = [tableView dequeueReusableCellWithIdentifier:@"WZIndexItemTableViewCell"];
    if (!itemCell) {
        itemCell = [[[NSBundle mainBundle]loadNibNamed:@"WZIndexItemTableViewCell" owner:self options:nil]lastObject];
        itemCell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        WZIndex *index = self.wzIndex[indexPath.row];
        if (index) {
            itemCell.indexTitleLabel.text = index.title;
            itemCell.indexDegreeLabel.text = index.zs;
            itemCell.indexDescLabel.text = index.des;
            itemCell.indexPicImageView.image = [UIImage imageNamed:[WZWeatherTool getIndexPicWithRow:indexPath.row]];
        }
        
    }
    return itemCell;
}

@end
