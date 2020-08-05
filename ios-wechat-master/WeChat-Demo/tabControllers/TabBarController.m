//
//  TabBarController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _chatView = [[ChatViewController alloc]init];
    [self addChildViewController:_chatView withTitle:@"聊天" Image:@"微信" selectedImage:@"微信"];
    
    _addressView = [[AddressViewController alloc]init];
    [self addChildViewController:_addressView withTitle:@"通讯录" Image:@"通讯录" selectedImage:@"通讯录"];
    
    _myView = [[MyViewController alloc]init];
    [self addChildViewController:_myView withTitle:@"我的" Image:@"我的" selectedImage:@"我的"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)addChildViewController:(UIViewController *)childController withTitle:(NSString*)title Image:(NSString*)imageName selectedImage:(NSString*)selectedImageName{
    childController.title = title;
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    //为每个tab的controller添加导航控制器
    UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:childController];
    [self addChildViewController:navController];
}



@end
