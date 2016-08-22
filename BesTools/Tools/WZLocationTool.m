//
//  WZLocationTool.m
//  Weather
//
//  Created by 张武星 on 15/5/23.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import "WZLocationTool.h"

#define kSystemVersion  [[[UIDevice currentDevice] systemVersion] floatValue]
@interface WZLocationTool ()
@end

@implementation WZLocationTool

-(void)startLocationManager{
    self.locationManager = [[CLLocationManager alloc]init];
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        if (kSystemVersion >= 8.0) {
            [self.locationManager requestAlwaysAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        [self performSelector:@selector(didTimeOut:) withObject:nil afterDelay:10];
    }
}

-(void)stopLocationManager{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(didTimeOut:) object:nil];
    if (self.locationManager) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
    }
}

-(void)didTimeOut:(id)obj{
    [self stopLocationManager];
    [self.delegate locationFailed];
}

#pragma mark - location manager delegate

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self stopLocationManager];
    [self.delegate locationFailed];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.location = locations.lastObject;
    [self stopLocationManager];
    [self.delegate locationReceived:self.location];
}
@end
