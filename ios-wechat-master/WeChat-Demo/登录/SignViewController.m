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
#import "accountModel.h"


@interface SignViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

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
//自动登录选项
@property (nonatomic, strong) UILabel *autoSignInLabel;
@property (nonatomic, strong) UIButton *btnSelect;
//记住密码
@property (nonatomic, strong) UILabel *inPasswordLabel;
@property (nonatomic, strong) UIButton *inPasswordBtn;
//获取本地库里的数据
@property (nonatomic, strong) NSArray *accountArray;
//显示账号的tableView
@property (nonatomic, strong) UITableView *accountTableview;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
NSString *infopassword;

@implementation SignViewController
- (NSArray *)accountArray {
    if (!_accountArray) {
        _accountArray = [NSArray array];
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
        NSString *filepath = [path stringByAppendingPathComponent:@"account.plist"];
        _accountArray = [NSArray arrayWithContentsOfFile:filepath];
    }
    return _accountArray;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //UIview添加手势(点击退出账号列表)
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
    //初始化图标
    [self setUpIconImageView];
    
    //初始化账号输入框
    [self setUpAccoutField];
    
    //初始化密码输入框
    [self setUpPasswordField];
    
    //初始化自动登录
    [self setUpAutoSignInLabel];
    
    //初始化登录按钮
    [self setUpSignInButton];
    
    //初始化注册按钮
    [self setUpRegisterButton];
  
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
    if (_username) {
        _accountField.text = _username;
        _username = nil;
    }
    _accountField.delegate = self;
    _accountField.selected = NO;
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
    if (_password) {
        _passwordField.text = _password;
        _password = nil;
    }
    _passwordField.secureTextEntry = YES;
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
#pragma mark - 初始化自动登录.修改密码
- (void)setUpAutoSignInLabel {
    _btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSelect.layer.cornerRadius = 3.0;
    _btnSelect.layer.borderWidth = 1;
    _btnSelect.layer.borderColor = [UIColor grayColor].CGColor;
    [_btnSelect setImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateSelected];
    _btnSelect.tag = 1;
    [_btnSelect addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnSelect];
    _btnSelect.sd_layout
    .topSpaceToView(_passwordField, 15)
    .heightIs(20)
    .leftEqualToView(self.passwordField)
    .widthIs(20);
    
    _autoSignInLabel = [[UILabel alloc] init];
    _autoSignInLabel.text = @"自动登录";
    _autoSignInLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_autoSignInLabel];
    _autoSignInLabel.sd_layout
    .topSpaceToView(_passwordField, 12)
    .leftSpaceToView(_btnSelect,3)
    .widthIs(80)
    .heightIs(25);
    
    _inPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _inPasswordBtn.layer.cornerRadius = 3.0;
    _inPasswordBtn.layer.borderWidth = 1;
    _inPasswordBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [_inPasswordBtn setImage:[UIImage imageNamed:@"打勾"] forState:UIControlStateSelected];
    _inPasswordBtn.tag = 2;
    [_inPasswordBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_inPasswordBtn];
    _inPasswordBtn.sd_layout
    .topSpaceToView(_btnSelect, 15)
    .heightIs(20)
    .leftEqualToView(_btnSelect)
    .widthIs(20);
    
    _inPasswordLabel = [[UILabel alloc] init];
    _inPasswordLabel.text = @"记住密码";
    _inPasswordLabel.textColor = [UIColor grayColor];
    [self.view addSubview:_inPasswordLabel];
    _inPasswordLabel.sd_layout
    .topSpaceToView(_autoSignInLabel, 12)
    .leftSpaceToView(_inPasswordBtn,3)
    .widthIs(80)
    .heightIs(25);
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
    .topSpaceToView(_inPasswordBtn, 20)
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
    .topSpaceToView(_inPasswordBtn, 20)
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
        if (uesr.uid) {
            NSLog(@"登陆成功");
            //传递密码（修改密码时用到）
            infopassword = passWord;
            [self writeToPlist];
            TabBarController *tabBarController = [[TabBarController alloc] init];
            //[tabBarController setupChatView];
            [self presentViewController:tabBarController animated:YES completion:nil];
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
    //[self.delegate changeTpRegisterVC];
    registerViewController *a = [[registerViewController alloc] init];
    [self presentViewController:a animated:YES completion:nil];
}
#pragma mark - 初始化控制器
-(instancetype)initWithInfo:(NSDictionary *)dict {
    self = [super init];
    self.username = dict[@"username"];
    self.password = dict[@"password"];
    return self;
}
#pragma mark 点击按钮
- (void)btnClick:(UIButton *)button {
    if (button.tag == 1) {
        //自动登录
        button.selected = !button.selected;
        _inPasswordBtn.selected = button.selected;
        if (button.selected) {
            
        }
    }else {
        //修改密码
        button.selected = !button.selected;
        if (button.selected) {
            
        }
    }
}
#pragma mark - 把信息写进plist文件
- (void)writeToPlist {
    [self dataIsRepeat:_accountField.text];
    //获取沙盒文件里面的collect.plist路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
    NSString *filepath = [path stringByAppendingPathComponent:@"account.plist"];
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([NSMutableArray arrayWithContentsOfFile:filepath]==nil) {
        NSArray *kArr = [NSArray array];
        BOOL ret = [kArr writeToFile:filepath atomically:YES];
        if (ret) {
            dataArray = [NSMutableArray arrayWithContentsOfFile:filepath];
        }
        else
        {
            NSLog(@"创建collect.plist失败了");
        }
        
    }
    else{
        dataArray = [NSMutableArray arrayWithContentsOfFile:filepath];
    }
    NSDictionary *dict = [NSDictionary dictionary];
    if (_btnSelect.selected) {
        //自动登录
        dict = @{
                 @"username":_accountField.text,
                 @"password":_passwordField.text,
                 @"autoLogin":@YES,
                 @"remindpassword":@YES
                 };
        [dataArray insertObject:dict atIndex:0];
        [dataArray writeToFile:filepath atomically:YES];
    }else if (_inPasswordBtn.selected) {
        //记住密码
        dict = @{
                 @"username":_accountField.text,
                 @"password":_passwordField.text,
                 @"autoLogin":@NO,
                 @"remindpassword":@YES
                 };
         [dataArray insertObject:dict atIndex:0];
        [dataArray writeToFile:filepath atomically:YES];
    }else {
        //只是记住账号
        dict = @{
                 @"username":_accountField.text,
                 @"autoLogin":@NO,
                 @"remindpassword":@NO
                 };
        [dataArray insertObject:dict atIndex:0];
        [dataArray writeToFile:filepath atomically:YES];
    }
    NSLog(@"%@",filepath);
}
#pragma mark - textField代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    _btnSelect.selected = NO;
    _inPasswordBtn.selected = NO;
    if (self.accountArray.count) {
        //展示账号数据
        _accountTableview = [[UITableView alloc] init];
        _accountTableview.dataSource = self;
        _accountTableview.delegate = self;
        _accountTableview.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.view addSubview:_accountTableview];
        _accountTableview.sd_layout
        .topSpaceToView(_accountField, 10)
        .leftEqualToView(_accountField)
        .rightEqualToView(_accountField)
        .heightIs(90);
        _accountTableview.tableFooterView = [[UIView alloc] init];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [_accountTableview removeFromSuperview];
}

#pragma mark - 判断数据是否有重合
- (void)dataIsRepeat:(NSString *)username {
    NSMutableArray *array = [NSMutableArray array];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)[0];
    NSString *filepath = [path stringByAppendingPathComponent:@"account.plist"];
    array = [NSMutableArray arrayWithContentsOfFile:filepath];
    for (int i=0; i<self.accountArray.count; i++) {
        NSDictionary *dict = self.accountArray[i];
        if ([username isEqualToString:dict[@"username"]]) {
            [array removeObject:dict];
            [array writeToFile:filepath atomically:YES];
        }
    }
}
#pragma mark - tableView的代理方法
//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.accountArray.count;
}
//每行显示的内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"dataID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell){
       cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
   // cell.backgroundColor = [UIColor grayColor];
    NSDictionary *dict = self.accountArray[indexPath.row];
    accountModel *model = [accountModel accountdataWithdict:dict];
    cell.textLabel.text = model.username;
    return cell;
}
//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.accountArray[indexPath.row];
    accountModel *model = [accountModel accountdataWithdict:dict];
    _accountField.text = model.username;
    _passwordField.text = model.password;
    if (model.autoLogin) {
        _btnSelect.selected = YES;
    }
    if (model.remindpassword) {
        _inPasswordBtn.selected = YES;
    }
    [_accountTableview removeFromSuperview];
}
#pragma mark -点击屏幕空白处去除tableView
- (void)handleSingleTap {
    [_accountTableview removeFromSuperview];
}
#pragma mark - 解决tableView点击失效
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
