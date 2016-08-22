//
//  WZHttpTool.h
//  Weather
//
//  Created by 张武星 on 15/5/20.
//  Copyright (c) 2015年 worthy.zhang. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kWZHttpTool [WZHttpTool sharedHttpTool]
@interface WZHttpTool : NSObject
+ (WZHttpTool *) sharedHttpTool;

-(void)weatherRequestWithCityInfo:(NSString *)cityInfo
                        success:(void(^)(id)) success
                        failure:(void(^)(id)) failure;

@end
