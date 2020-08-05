//
//  registerViewController.m
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "registerViewController.h"
#import "SignViewController.h"
#import "SDAutoLayout.h"
#import <JMessage/JMessage.h>

@interface registerViewController ()

//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//账号输入行
@property (nonatomic, strong) UITextField *accoutField;
//密码输入行
@property (nonatomic, strong) UITextField *passwordField;
//注册按钮
@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation registerViewController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化返回按钮
    [self setUpBackButton];
    
    //初始化头像
    [self setUpIconImageView];
    
    //初始化账号输入框
    [self setUpAccoutField];
    
    //初始化密码输入框
    [self setUpPasswordField];
    
    //初始化注册按钮
    [self setUpRegisterButton];
}

#pragma mark - 初始化返回按钮
- (void)setUpBackButton {
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    _backButton.backgroundColor = [UIColor whiteColor];
    [_backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backButton];
    _backButton.sd_layout
    .topSpaceToView(self.view, 30)
    .leftSpaceToView(self.view, 30)
    .widthIs(50)
    .heightIs(41);
}
#pragma mark - 初始化头像
- (void)setUpIconImageView {
    self.iconImageView =[[UIImageView alloc] init];
    self.iconImageView.layer.cornerRadius = 50;
    self.iconImageView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.borderWidth = 1;
    self.iconImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.iconImageView];
    self.iconImageView.sd_layout
    .topSpaceToView(self.view, 131)
    .leftSpaceToView(self.view, 144)
    .widthIs(100)
    .heightIs(100);
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
    .topSpaceToView(self.iconImageView, 30)
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
    .leftSpaceToView(self.view, 100)
    .widthIs(180)
    .heightIs(41);
}
#pragma mark - 点击注册按钮
- (void)clickRegisterButton {
    NSLog(@"%@",_accoutField.text);
    NSLog(@"%@",_passwordField.text);
    NSLog(@"%@",_iconImageView.image);
    NSString *username = _accoutField.text;
    NSString *password = _passwordField.text;
    [JMSGUser registerWithUsername:username password:password completionHandler:^(id resultObject, NSError *error) {
        NSLog(@"%@",resultObject);
    }];
}
#pragma mark - 点击返回按钮
- (void)clickBackButton {
    SignViewController *signVc = [[SignViewController alloc] init];
    [self presentViewController:signVc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
