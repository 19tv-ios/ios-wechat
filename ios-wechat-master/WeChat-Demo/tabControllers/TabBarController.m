//
//  TabBarController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "TabBarController.h"
#import "GetConversation.h"
#import <AFNetworking.h>
#import "NoNetWork.h"
#import <SDAutoLayout.h>
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWeight [UIScreen mainScreen].bounds.size.width
@interface TabBarController ()

@end

@implementation TabBarController{
    bool hasMenu;
    bool firstTime;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    firstTime = YES;
    _chatView = [[ChatViewController alloc]init];
    [self addChildViewController:_chatView withTitle:@"聊天" Image:@"聊天1" selectedImage:@"聊天1"];
    _chatView.getModel = [[GetConversation alloc]init];
    _chatView.delegate = self;
    self.chatView.getModel.delegate = self.chatView;
    self.chatView.getMsg.delegate = self.chatView;
    [_chatView.getModel getConversation];
    [_chatView getMsgModel];
    
    _addressView = [[AddressViewController alloc]init];
    [self addChildViewController:_addressView withTitle:@"通讯录" Image:@"通讯录1" selectedImage:@"通讯录1"];
    
    _myView = [[MyViewController alloc]init];
    [self addChildViewController:_myView withTitle:@"个人中心" Image:@"个人中心1" selectedImage:@"个人中心1"];
    
    AFNetworkReachabilityManager* networkManger = [AFNetworkReachabilityManager sharedManager];
    [networkManger startMonitoring];
    [networkManger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *result = @"";
        NoNetWork* view = [[NoNetWork alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                result = @"未知网络";
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [view setup];
                self->_chatView.tableview.tableHeaderView = view;
                result = @"无网络";
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                result = @"WAN";
                self->_chatView.tableview.tableHeaderView = [[UIView alloc]init];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                self->_chatView.tableview.tableHeaderView = [[UIView alloc]init];
                result = @"WIFI";
                break;
                
            default:
                break;
        }
        NSLog(@"%@",result);
    }];
    

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
-(void)bringMenu:(PlusMenu*)view{
    if(firstTime == YES){
        _menu = [[PlusMenu alloc]init];
        _menu = view;
        [self.view addSubview:_menu.view];
        firstTime = NO;
        _menu.hasMenu = YES;
    }else{
        if(_menu.hasMenu == NO){
            _menu.view.hidden = NO;
            _menu.hasMenu = YES;
        }else{
            _menu.view.hidden = YES;
            _menu.hasMenu = NO;
        }
    }
}



@end
