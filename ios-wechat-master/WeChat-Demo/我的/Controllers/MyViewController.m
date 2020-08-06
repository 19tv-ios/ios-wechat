//
//  MyViewController.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "MyViewController.h"
#import "SDAutoLayout.h"
#import <JMessage/JMessage.h>

@interface MyViewController()
//详细信息UIView
@property (nonatomic, strong) UIView *cardView;
//头像呢称UIView
@property (nonatomic, strong) UIView *iconView;
//头像
@property (nonatomic, strong) UIImageView *iconImageView;
//呢称
@property (nonatomic, strong) UILabel *nameLabel;
//生日
@property (nonatomic, strong) UILabel *birthdayLabel;
//性别
@property (nonatomic, strong) UILabel *genderLabel;
//签名
@property (nonatomic, strong) UILabel *autographLabel;
//分割线1
@property (nonatomic, strong) UIView *dividingLine1;
//分割线2
@property (nonatomic, strong) UIView *dividingLine2;
//修改密码的button
@property (nonatomic, strong) UIButton *changePasswordButton;
//退出登录的button
@property (nonatomic, strong) UIButton *signOutButton;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.950 green:0.950 blue:0.950 alpha:1.0];
    
    //初始化UIView
    [self setUpCardView];
    
    //初始化iconView
    [self setUpIconView];
    
    //初始化修改密码按钮
    [self setUpchangePasswordButton];
    
    //初始化退出登录按钮
    [self setUpSignOutButton];
    
    //初始化头像
    [self setUpIconImageView];
    
    //初始化呢称标签
    [self setUpNameLabel];
    
    //初始化生日标签
    [self setUpBirthdayLabel];
    
    //初始化性别标签
    [self setUpGenderLabel];
    
    //初始化签名标签
    [self setUpAutographLabel];
    
    //初始化分割线
    [self setUpDividingLine];
    
}
#pragma mark - 初始化UIView
- (void)setUpCardView {
    _cardView = [[UIView alloc] init];
    _cardView.backgroundColor = [UIColor colorWithRed:242/255.0 green:149/255.0 blue:92/255.0 alpha:0.75];
    [self.view addSubview:_cardView];
    _cardView.layer.cornerRadius=20.0;
    _cardView.layer.borderWidth = 2.f;
    CGFloat top = (self.view.frame.size.height - 350)/2;
    CGFloat left = (self.view.frame.size.width - 280)/2 + 30;
    _cardView.sd_layout
    .widthIs(280)
    .heightIs(350)
    .topSpaceToView(self.view, top)
    .leftSpaceToView(self.view, left);
}
#pragma mark - 初始化iconView
- (void)setUpIconView {
    _iconView = [[UIView alloc] init];
    _iconView.backgroundColor = [UIColor colorWithRed:184/255.0 green:205/255.0 blue:233/255.0 alpha:0.75];
    [self.view addSubview:_iconView];
    _iconView.layer.cornerRadius=10.0;
    _iconView.layer.borderWidth = 2.f;
    CGFloat top = (self.view.frame.size.height - 380)/2 - 100;
    CGFloat left = (self.view.frame.size.width - 280)/2 - 40;
    _iconView.sd_layout
    .widthIs(280)
    .heightIs(80)
    .topSpaceToView(self.view, top)
    .leftSpaceToView(self.view, left);
}
#pragma mark - 初始化修改密码按钮
- (void)setUpchangePasswordButton {
    _changePasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_changePasswordButton setTitle:@"修改密码" forState:UIControlStateNormal];
    _changePasswordButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _changePasswordButton.layer.cornerRadius=5.0;
    [_changePasswordButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _changePasswordButton.backgroundColor = [UIColor colorWithRed:86/255.0 green:166/255.0 blue:249/255.0 alpha:1.0];
    [_changePasswordButton addTarget:self action:@selector(clickchangePasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_changePasswordButton];
    CGFloat width = self.view.frame.size.width - 38 - 38 - 55;
    _changePasswordButton.sd_layout
    .topSpaceToView(self.cardView, 30)
    .leftSpaceToView(self.view, 18)
    .widthIs(width/2)
    .heightIs(41);
}
#pragma mark - 初始化退出登录按钮
- (void)setUpSignOutButton {
    _signOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    _signOutButton.titleLabel.font = [UIFont systemFontOfSize:15];
    _signOutButton.layer.cornerRadius=5.0;
    [_signOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signOutButton.backgroundColor = [UIColor colorWithRed:228/255.0 green:173/255.0 blue:178/255.0 alpha:1.0];
    [_signOutButton addTarget:self action:@selector(clickSignOutButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signOutButton];
    CGFloat width = self.view.frame.size.width - 38 - 38 - 55;
    _signOutButton.sd_layout
    .topSpaceToView(self.changePasswordButton, 13)
    .leftSpaceToView(self.view, 18)
    .widthIs(width/2)
    .heightIs(41);
}
#pragma mark - 点击修改密码按钮
- (void)clickchangePasswordButton {
    
}
#pragma mark - 点击退出登录按钮
- (void)clickSignOutButton {
    
}
#pragma mark - 初始化头像
- (void)setUpIconImageView {
    self.iconImageView =[[UIImageView alloc] init];
    self.iconImageView.image = [UIImage imageNamed:@"用户"];
    self.iconImageView.layer.cornerRadius = 30;
    self.iconImageView.layer.masksToBounds = YES;
    [self.iconView addSubview:self.iconImageView];
    _iconImageView.sd_layout
    .leftSpaceToView(self.iconView, 20)
    .widthIs(60)
    .heightIs(60)
    .topSpaceToView(self.iconView, 10);
}
#pragma mark - 初始化呢称标签
- (void)setUpNameLabel {
    _nameLabel = [[UILabel alloc] init];
    //获取当前登录用户呢称
    JMSGUser *user = [JMSGUser myInfo];
    _nameLabel.text = user.username;
    [_iconView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .leftSpaceToView(self.iconImageView, 20)
    .widthIs(220)
    .heightIs(60)
    .topEqualToView(_iconImageView);
}
#pragma mark - 初始化生日标签
- (void)setUpBirthdayLabel {
    _birthdayLabel = [[UILabel alloc] init];
    _birthdayLabel.text = @"生日:";
    [_cardView addSubview:_birthdayLabel];
    _birthdayLabel.sd_layout
    .leftSpaceToView(self.cardView, 20)
    .widthIs(50)
    .heightIs(60)
    .topSpaceToView(_cardView, 10);
}
#pragma mark - 初始化性别标签
- (void)setUpGenderLabel {
    _genderLabel = [[UILabel alloc] init];
    _genderLabel.text = @"性别:";
    [_cardView addSubview:_genderLabel];
    _genderLabel.sd_layout
    .leftSpaceToView(self.cardView, 20)
    .widthIs(50)
    .heightIs(60)
    .topSpaceToView(_birthdayLabel, 30);
}
#pragma mark - 初始化签名标签
- (void)setUpAutographLabel {
    _autographLabel = [[UILabel alloc] init];
    _autographLabel.text = @"签名:";
    [_cardView addSubview:_autographLabel];
    _autographLabel.sd_layout
    .leftSpaceToView(self.cardView, 20)
    .widthIs(50)
    .heightIs(60)
    .topSpaceToView(_genderLabel, 30);
}
#pragma mark - 初始化分割线
- (void)setUpDividingLine {
    _dividingLine1 = [[UIView alloc] init];
    _dividingLine1.backgroundColor = [UIColor whiteColor];
    [self.cardView addSubview:_dividingLine1];
    _dividingLine1.sd_layout
    .widthIs(280)
    .heightIs(2)
    .topSpaceToView(self.birthdayLabel,5)
    .leftSpaceToView(self.cardView, 0);
    
    _dividingLine2 = [[UIView alloc] init];
    _dividingLine2.backgroundColor = [UIColor whiteColor];
    [self.cardView addSubview:_dividingLine2];
    _dividingLine2.sd_layout
    .widthIs(280)
    .heightIs(2)
    .topSpaceToView(self.genderLabel,5)
    .leftSpaceToView(self.cardView, 0);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
