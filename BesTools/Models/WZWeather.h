//
//  WZWeather.h
//  Weather
//
//  Created by 张武星 on 15/5/20.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "WZResults.h"
@interface WZWeather : JSONModel
@property(nonatomic,assign)int error;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,strong)NSArray<WZResults> *results;
@end
