//
//  WZIndex.h
//  Weather
//
//  Created by 张武星 on 15/5/22.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "JSONModel.h"
@protocol WZIndex
@end
@interface WZIndex : JSONModel
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *zs;
@property(nonatomic,copy)NSString *tipt;
@property(nonatomic,copy)NSString *des;
@end
