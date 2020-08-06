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

@interface registerViewController ()<UITextFieldDelegate>

//返回按钮
@property (nonatomic, strong) UIButton *backButton;
//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//账号输入行
@property (nonatomic, strong) UITextField *accountField;
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
    self.iconImageView.layer.borderWidth = 0;
    self.iconImageView.layer.masksToBounds = YES;
    [_iconImageView setImage:[UIImage imageNamed:@"注册登录"]];
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
    _accountField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _accountField.layer.borderWidth=1.0f;
    _accountField.layer.cornerRadius=5.0;
    _accountField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _accountField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _accountField.leftViewMode=UITextFieldViewModeAlways;
    [self.view addSubview:_accountField];
    _accountField.sd_layout
    .topSpaceToView(self.iconImageView, 30)
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
    _passwordField.delegate = self;
}

#pragma mark - 初始化注册按钮
- (void)setUpRegisterButton {
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerButton setTitle:@"Register" forState:UIControlStateNormal];
    _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _registerButton.layer.cornerRadius=5.0;
    _registerButton.backgroundColor = [UIColor colorWithRed:0.110 green:0.592 blue:0.557 alpha:1.0];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerButton addTarget:self action:@selector(clickRegisterButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerButton];
    _registerButton.sd_layout
    .topSpaceToView(self.passwordField, 30)
    .leftSpaceToView(self.view, 100)
    .rightSpaceToView(self.view, 100)
    .heightIs(41);
}
#pragma mark - 点击注册按钮
- (void)clickRegisterButton {
    NSString *username = _accountField.text;
    NSString *password = _passwordField.text;
    [JMSGUser registerWithUsername:username password:password completionHandler:^(id resultObject, NSError *error) {
        if (self->_passwordField.text.length&&self->_accountField.text.length) {
            if (resultObject) {
                SignViewController *signViewController = [[SignViewController alloc] init];
                [self presentViewController:signViewController animated:YES completion:^{
                    //通知传值.更新登录页面的账号和密码
                    NSDictionary *dict = @{
                                           @"accoutField":self->_accountField.text,
                                           @"passwordField":self->_passwordField.text
                                           };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"register" object:nil userInfo:dict];
                }];
            }else {
                if ([self accoutIsOK]) {
                    //提示信息有误
                    NSString *title = @"用户名已存在";
                    [self showAlert:title];
                    self->_accountField.text = nil;
                    self->_passwordField.text = nil;
                }else {
                    //提示用户名不正确
                    
                }
            }
        }else {
            if (self->_accountField.text.length) {
                //提示输入密码
                NSString *title = @"请输入密码";
                [self showAlert:title];
            }else {
                //提示输入账号
                NSString *title = @"请输入账号";
                [self showAlert:title];
            }
        }
       
    }];
}
#pragma mark - 点击返回按钮
- (void)clickBackButton {
    SignViewController *signVc = [[SignViewController alloc] init];
    [self presentViewController:signVc animated:YES completion:nil];
}
#pragma mark - 判断账号信息
- (BOOL)accoutIsOK {
    NSString *account = _accountField.text;
    unichar  firstStr = [account characterAtIndex:0];
    //判断账号的长度是否在4到128个字节
    if (_accountField.text.length>=4&&_accountField.text.length<=128) {
        //判断是否是以字母或者数字开头
        if (isdigit(firstStr)||isalpha(firstStr)) {
            //判断是否包含不支持的字符
            NSError *error;
            NSRegularExpression *regex = [NSRegularExpression
                                          regularExpressionWithPattern:@"[_.-。@]|^[A-Za-z0-9]+$"
                                          options:0
                                          error:&error];
            NSTextCheckingResult *match = [regex firstMatchInString:account
                                                            options:0
                                                              range:NSMakeRange(0, [_accountField.text length])];
            NSLog(@"%ld-%ld",match.range.length,_accountField.text.length);
            if (match.range.length == _accountField.text.length) {
                return YES;
            }else{
                NSString *title = @"Username以字母或者数字开头。支持字母、数字、下划线、英文点、减号、 @。";
                [self showAlert:title];
                return NO;
            }
        }else {
            NSString *title = @"Username以字母或者数字开头。支持字母、数字、下划线、英文点、减号、 @。";
            [self showAlert:title];
            return NO;
        }
    }else {
        //提示账号字节限制
        NSString *title = @"Uesrname长度限制为4到128个字节";
        [self showAlert:title];
        return NO;
    }
    return YES;
}
#pragma mark - 提示框
- (void)showAlert:(NSString *) title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 内存释放
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
