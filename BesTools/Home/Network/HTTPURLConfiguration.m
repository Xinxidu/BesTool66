//
//  HTTPURLConfiguration.m
//  ZhihuDaily
//
//  Created by 钟武 on 16/8/3.
//  Copyright © 2016年 钟武. All rights reserved.
//

#import "HTTPURLConfiguration.h"

@interface HTTPURLConfiguration ()

@property (nonatomic, copy) NSString *zhiHuDomain;

@end

@implementation HTTPURLConfiguration

SYNTHESIZE_SINGLETON_FOR_CLASS(HTTPURLConfiguration)

- (id)init{
    if (self = [super init]) {
        _zhiHuDomain = @"http://news-at.zhihu.com/api/4/";
        [self configureRestfulURL];
    }
    
    return self;
}

- (void)configureRestfulURL{
    _latestNews = [self zhiHuURLWithPath:@"news/latest"];
    _previousNews = [self zhiHuURLWithPath:@"news/before/"];
    _detailNews = [self zhiHuURLWithPath:@"news/"];
    _themesList = [self zhiHuURLWithPath:@"themes"];
    _theme = [self zhiHuURLWithPath:@"theme/"];
    _launchImage = [self zhiHuURLWithPath:@"start-image/"];
}

- (NSString *)zhiHuURLWithPath:(NSString *)path{
    return [self.zhiHuDomain stringByAppendingString:path];
}

@end
