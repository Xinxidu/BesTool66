//
//  WZLocationTool.h
//  Weather
//
//  Created by 张武星 on 15/5/23.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol WZLocationToolDelegate <NSObject>
-(void)locationReceived:(CLLocation*)location;
-(void)locationFailed;
@end

@interface WZLocationTool : NSObject<CLLocationManagerDelegate>
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)CLLocation *location;

-(void)startLocationManager;

@property(nonatomic,weak)id<WZLocationToolDelegate> delegate;
@end
