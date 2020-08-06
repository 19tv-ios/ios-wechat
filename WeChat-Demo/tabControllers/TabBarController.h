//
//  TabBarController.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "AddressViewController.h"
#import "MyViewController.h"
@interface TabBarController : UITabBarController

@property(nonatomic,strong)ChatViewController* chatView;//聊天页

@property(nonatomic,strong)AddressViewController* addressView;//通讯录页

@property(nonatomic,strong)MyViewController* myView;//我的页

- (void)addChildViewController:(UIViewController *)childController withTitle:(NSString*)title Image:(NSString*)imageName selectedImage:(NSString*)selectedImageName;
@end
