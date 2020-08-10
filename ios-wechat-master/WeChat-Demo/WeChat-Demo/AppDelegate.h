//
//  AppDelegate.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarController.h"
#import "SignViewController.h"
#import "registerViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TabBarController* tabBarController;

@property (strong, nonatomic) SignViewController *signViewController;

@property (strong, nonatomic) registerViewController *registerViewController;


@end

