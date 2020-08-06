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

//图片
@property (nonatomic, strong) UIImageView *iconImageView;
//账号输入行
@property (nonatomic, strong) UITextField *accountField;
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
    
    //初始化图标
    [self setUpIconImageView];
    
    //初始化账号输入框
    [self setUpAccoutField];
    
    //初始化密码输入框
    [self setUpPasswordField];
    
    //初始化登录按钮
    [self setUpSignInButton];
    
    //初始化注册按钮
    [self setUpRegisterButton];
    
    //监听注册账号成功的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(register:) name:@"register" object:nil];
}
#pragma mark - 初始化图标
- (void)setUpIconImageView {
    self.iconImageView =[[UIImageView alloc] init];
    self.iconImageView.layer.cornerRadius = 50;
    self.iconImageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 0;
    self.iconImageView.layer.masksToBounds = YES;
    [_iconImageView setImage:[UIImage imageNamed:@"微信1"]];
    [self.view addSubview:self.iconImageView];
    CGFloat left = (self.view.frame.size.width - 38 -38)/2 - 10;
    self.iconImageView.sd_layout
    .topSpaceToView(self.view, 100)
    .leftSpaceToView(self.view, left)
    .widthIs(100)
    .heightIs(100);
}
#pragma mark - 初始化账号输入框
- (void)setUpAccoutField {
    _accountField = [[UITextField alloc] init];
    _accountField.placeholder = @"Username";
    _accountField.layer.borderWidth=1.0f;
    _accountField.layer.cornerRadius=5.0;
    _accountField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _accountField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _accountField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _accountField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_accountField];
    _accountField.sd_layout
    .topSpaceToView(self.view, 250)
    .leftSpaceToView(self.view, 38)
    .rightSpaceToView(self.view, 38)
    .heightIs(42);
}
#pragma  mark - 初始化密码输入框
- (void)setUpPasswordField {
    _passwordField = [[UITextField alloc] init];
    _passwordField.placeholder = @"Password";
    _passwordField.layer.borderWidth=1.0f;
    _passwordField.layer.cornerRadius=5.0;
    _passwordField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _passwordField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _passwordField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _passwordField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_passwordField];
    _passwordField.sd_layout
    .topSpaceToView(self.accountField, 30)
    .leftSpaceToView(self.view, 38)
    .rightSpaceToView(self.view, 38)
    .heightIs(42);
}
#pragma mark - 初始化登录按钮
- (void)setUpSignInButton {
    _signIntButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signIntButton setTitle:@"Login" forState:UIControlStateNormal];
    _signIntButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _signIntButton.layer.cornerRadius=5.0;
    [_signIntButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signIntButton.backgroundColor = [UIColor colorWithRed:0.161 green:0.169 blue:0.353 alpha:1.0];
    [_signIntButton addTarget:self action:@selector(clickSignIntButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signIntButton];
    CGFloat width = self.view.frame.size.width - 38 - 38 - 55;
    _signIntButton.sd_layout
    .topSpaceToView(self.passwordField, 30)
    .leftSpaceToView(self.view, 38)
    .widthIs(width/2)
    .heightIs(41);
}
#pragma mark - 初始化注册按钮
- (void)setUpRegisterButton {
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"Register" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _registerButton.layer.cornerRadius=5.0;
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerButton.backgroundColor = [UIColor colorWithRed:0.110 green:0.592 blue:0.557 alpha:1.0];
    [_registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    _registerButton.sd_layout
    .topSpaceToView(self.passwordField, 30)
    .leftSpaceToView(self.signIntButton, 55)
    .rightEqualToView(self.passwordField)
    .heightIs(41);
}
#pragma mark - 点击登录按钮
- (void)clickSignIntButton {
    NSString *username = _accountField.text;
    NSString *passWord = _passwordField.text;
    [JMSGUser loginWithUsername:username password:passWord completionHandler:^(id resultObject, NSError *error) {
        JMSGUser *uesr = resultObject;
        NSLog(@"登陆成功");
        if (uesr.uid) {
            TabBarController *tabBarC = [[TabBarController alloc] init];
            [self presentViewController:tabBarC animated:YES completion:nil];
            //[self.delegate changeRootVC];
        }else{
            //提示信息有误
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"账户信息有误.请重新输入" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}
#pragma mark - 点击注册按钮
- (void)clickRegisterButton {
    registerViewController *registerVc = [[registerViewController alloc] init];
    [self presentViewController:registerVc animated:YES completion:nil];
}
#pragma mark- 注册成功
- (void)register:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    _accountField.text = dict[@"accoutField"];
    _passwordField.text = dict[@"passwordField"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
