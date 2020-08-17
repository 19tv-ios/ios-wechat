//
//  AppDelegate.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "AppDelegate.h"
#import <JMessage/JMessage.h>
#import "Root.h"
#import <UserNotifications/UserNotifications.h>
#import "accountModel.h"
#import <JMessage/JMessage.h>

#define appkey @"0a974aa68871f642444ae38b"
@interface AppDelegate ()<Root>

@end
extern NSString *infopassword;
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Required - 启动 JMessage SDK
    [JMessage setupJMessage:launchOptions appKey:appkey channel:nil apsForProduction:NO category:nil messageRoaming:NO];
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
    self.window = [ [UIWindow alloc] initWithFrame:[[UIScreen mainScreen]bounds] ];
    //启动完成后显示状态栏
    UIApplication* app = [UIApplication sharedApplication];
    app.statusBarHidden = NO;
    
    _tabBarController = [[TabBarController alloc] init];
    
    _signViewController = [[SignViewController alloc] init];
    _signViewController.delegate = self;
    
    _tabBarController.myView.delegate = self;
    
    _registerViewController = [[registerViewController alloc] init];
    _registerViewController.delegate = self;
    
        //根据自动登录设置根控制器
    NSArray *accountArray = [NSArray array];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
    NSString *filepath = [path stringByAppendingPathComponent:@"account.plist"];
    accountArray = [NSArray arrayWithContentsOfFile:filepath];
    if (accountArray.count) {
        NSDictionary *dict = accountArray.firstObject;
        accountModel *model = [accountModel accountdataWithdict:dict];
        if (model.autoLogin) {
            dispatch_group_t group = dispatch_group_create();
            dispatch_group_enter(group);
            [JMSGUser loginWithUsername:model.username password:model.password completionHandler:^(id resultObject, NSError *error) {
                if (error) {
                    self.window.rootViewController = self->_signViewController;
                }else {
                    infopassword = model.password;
                    self.window.rootViewController = self->_tabBarController;
                }
            }];
            dispatch_group_notify(group, dispatch_get_main_queue(), ^{
                NSLog(@"11");
            });
        }else {
            self.window.rootViewController = _signViewController;
        }
    }else {
        self.window.rootViewController = _signViewController;
   }
    
   // self.window.rootViewController = _signViewController;
    [self.window makeKeyAndVisible];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *plistPath = [paths objectAtIndex:0];//获取沙盒地址
    self.tabBarController.chatView.address = [plistPath stringByAppendingPathComponent:@"Chat.plist"];
    
    return YES;
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required - 注册token
    [JMessage registerDeviceToken:deviceToken];
}
- (void)updateUI {
    self.window.rootViewController = _tabBarController;
}
-(void)changeRootVC{
    self.window.rootViewController = _tabBarController;
}
-(void)changeToSignVC {
    self.window.rootViewController = _signViewController;
}
-(void)changeTpRegisterVC {
    self.window.rootViewController = _registerViewController;
}
- (void)win {
    [self.window makeKeyAndVisible];

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
