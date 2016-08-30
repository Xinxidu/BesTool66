//
//  AppDelegate.m
//  BesTools
//
//  Created by Aaron Lee on 16/8/18.
//  Copyright © 2016年 Aaron Lee. All rights reserved.

#import "AppDelegate.h"
#import "ZYTabBarController.h"
#import "LeftViewController.h"
#import "APIKey.h"
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    ZYTabBarController *mainVC = [[ZYTabBarController alloc]init];
    LeftViewController *leftVC = [[LeftViewController alloc]init];
    self.LeftSlideVC = [[LeftSlideViewController alloc]initWithLeftView:leftVC andMainView:mainVC];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:self.LeftSlideVC];
    mainNav.navigationBarHidden = YES;
    self.window.rootViewController = mainNav;
    [[UINavigationBar appearance] setBarTintColor:[UIColor orangeColor]];
    
    [self configureAPIKey];
    return YES;
}
- (void)configureAPIKey
{
    if ([APIKey length] == 0)
    {
        NSString *reason = [NSString stringWithFormat:@"apiKey为空，请检查key是否正确设置。"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:reason preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:action];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];    }
    
    [AMapServices sharedServices].apiKey = (NSString *)APIKey;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
