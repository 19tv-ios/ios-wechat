//
//  SignViewController.m
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "SignViewController.h"
#import "registerViewController.h"
#import "SDAutoLayout.h"
#import <JMessage/JMessage.h>
#import "TabBarController.h"


@interface SignViewController ()

//账号输入行
@property (nonatomic, strong) UITextField *accoutField;
//密码输入行
@property (nonatomic, strong) UITextField *passwordField;
//登录按钮
@property (nonatomic, strong) UIButton *signIntButton;
//注册按钮
@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation SignViewController



#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //初始化账号输入框
    [self setUpAccoutField];
    
    //初始化密码输入框
    [self setUpPasswordField];
    
    //初始化登录按钮
    [self setUpSignInButton];
    
    //初始化注册按钮
    [self setUpRegisterButton];
}

#pragma mark - 初始化账号输入框
- (void)setUpAccoutField {
    _accoutField = [[UITextField alloc] init];
    _accoutField.placeholder = @"Username";
    _accoutField.layer.borderWidth=1.0f;
    _accoutField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _accoutField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _accoutField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_accoutField];
    _accoutField.sd_layout
    .topSpaceToView(self.view, 250)
    .leftSpaceToView(self.view, 38)
    .widthIs(300)
    .heightIs(42);
}
#pragma  mark - 初始化密码输入框
- (void)setUpPasswordField {
    _passwordField = [[UITextField alloc] init];
    _passwordField.placeholder = @"Password";
    _passwordField.layer.borderWidth=1.0f;
    _passwordField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _passwordField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _passwordField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_passwordField];
    _passwordField.sd_layout
    .topSpaceToView(self.accoutField, 30)
    .leftSpaceToView(self.view, 38)
    .widthIs(300)
    .heightIs(42);
}
#pragma mark - 初始化登录按钮
- (void)setUpSignInButton {
    _signIntButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signIntButton setTitle:@"Login" forState:UIControlStateNormal];
    _signIntButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_signIntButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signIntButton.backgroundColor = [UIColor redColor];
    [_signIntButton addTarget:self action:@selector(clickSignIntButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signIntButton];
    _signIntButton.sd_layout
    .topSpaceToView(self.passwordField, 30)
    .leftSpaceToView(self.view, 38)
    .widthIs(122)
    .heightIs(41);
}
#pragma mark - 初始化注册按钮
- (void)setUpRegisterButton {
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"Register" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerButton.backgroundColor = [UIColor blueColor];
    [_registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    _registerButton.sd_layout
    .topSpaceToView(self.passwordField, 30)
    .leftSpaceToView(self.signIntButton, 55)
    .widthIs(122)
    .heightIs(41);
}
#pragma mark - 点击登录按钮
- (void)clickSignIntButton {
    NSString *username = _accoutField.text;
    NSString *passWord = _passwordField.text;
    [JMSGUser loginWithUsername:username password:passWord completionHandler:^(id resultObject, NSError *error) {
        JMSGUser *uesr = resultObject;
        NSLog(@"登陆成功");
        if (uesr.uid) {
            //TabBarController *tabBarC = [[TabBarController alloc] init];
            //[self presentViewController:tabBarC animated:YES completion:nil];
            [self.delegate changeRootVC];
        }
    }];
}
#pragma mark - 点击注册按钮
- (void)clickRegisterButton {
    registerViewController *registerVc = [[registerViewController alloc] init];
    [self presentViewController:registerVc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
