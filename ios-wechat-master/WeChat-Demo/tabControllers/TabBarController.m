//
//  TabBarController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "TabBarController.h"
#import "GetConversation.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _chatView = [[ChatViewController alloc]init];
    [self addChildViewController:_chatView withTitle:@"聊天" Image:@"微信" selectedImage:@"微信"];
    _chatView.getModel = [[GetConversation alloc]init];
    self.chatView.getModel.delegate = self.chatView;
    self.chatView.getMsg.delegate = self.chatView;
    [_chatView.getModel getConversation];
    [_chatView getMsgModel];
    
    _addressView = [[AddressViewController alloc]init];
    [self addChildViewController:_addressView withTitle:@"通讯录" Image:@"通讯录" selectedImage:@"通讯录"];
    
    _myView = [[MyViewController alloc]init];
    [self addChildViewController:_myView withTitle:@"个人中心" Image:@"我的" selectedImage:@"我的"];
    
    
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
