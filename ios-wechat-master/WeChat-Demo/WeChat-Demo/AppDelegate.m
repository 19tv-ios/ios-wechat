//
//  AppDelegate.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "AppDelegate.h"
#import <JMessage/JMessage.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [ [UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds] ];
    //启动完成后显示状态栏
    UIApplication* app = [UIApplication sharedApplication];
    app.statusBarHidden = NO;
    
   // _tabBarController = [[TabBarController alloc] init];
    _signViewController = [[SignViewController alloc] init];
    
    //self.window.rootViewController = _tabBarController;
    
    self.window.rootViewController = _signViewController;
    [self.window makeKeyAndVisible];
    
    NSString *appkey = @"0a974aa68871f642444ae38b";
    // Required - 启动 JMessage SDK
    [JMessage setupJMessage:launchOptions appKey:appkey channel:nil apsForProduction:NO category:nil  messageRoaming:YES];
    // Required - 注册 APNs 通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JMessage registerForRemoteNotificationTypes:(UNAuthorizationOptionBadge |
                                                      UNAuthorizationOptionSound |
                                                      UNAuthorizationOptionAlert)
                                          categories:nil];
    } else {
        //categories 必须为nil
        [JMessage registerForRemoteNotificationTypes:(UNAuthorizationOptionBadge |
                                                      UNAuthorizationOptionSound |
                                                      UNAuthorizationOptionAlert)
                                          categories:nil];
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册token
    [JMessage registerDeviceToken:deviceToken];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
