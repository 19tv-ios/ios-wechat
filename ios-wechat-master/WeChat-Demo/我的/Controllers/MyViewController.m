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
#import "SexPickerTool.h"
#import "DatePickerTool.h"
#import "changeInfoViewController.h"

@interface MyViewController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
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
//生日选择按钮
@property (nonatomic, strong) UIButton *birthdaySelectButton;
//生日填写框
@property (nonatomic, strong) UILabel *fillBirthdayLabel;
//性别
@property (nonatomic, strong) UILabel *genderLabel;
//点击出现选择性别按钮
@property (nonatomic, strong) UIButton *genderSelectButton;
//性别填写框
@property (nonatomic, strong) UILabel *fillGenderLabel;
//签名
@property (nonatomic, strong) UILabel *autographLabel;
//签名输入框
@property (nonatomic, strong) UILabel *fillAutographLabel;
//签名跳转按钮
@property (nonatomic, strong) UIButton *autographLabelSelectButton;
//分割线1
@property (nonatomic, strong) UIView *dividingLine1;
//分割线2
@property (nonatomic, strong) UIView *dividingLine2;
//修改密码的button
@property (nonatomic, strong) UIButton *changePasswordButton;
//退出登录的button
@property (nonatomic, strong) UIButton *signOutButton;

@end

NSInteger infoindex;

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
    
    //初始化生日选择按钮
    [self setUpBirthdaySelectButton];
    
    //初始化生日填写框
    [self setUpFillBirthdayLabel];
    
    //初始化性别标签
    [self setUpGenderLabel];
    
    //初始化点击性别选择按钮
    [self setUpGenderSelectButton];
    
    //初始化性别填写框
    [self seuUpFillGenderLabel];
    
    //初始化签名标签
    [self setUpAutographLabel];
    
    //初始化签名跳转按钮
    [self setUpAutographLabelSelectButton];
    
    //初始化签名输入框
    [self setUpFillAutographLabel];
    
    //初始化分割线
    [self setUpDividingLine];
    
    //监听修改内容通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(infoChange:) name:@"infoChange" object:nil];
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
    //添加手势
    _iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
    [_iconImageView addGestureRecognizer:singleTap];
}
#pragma mark - 初始化呢称标签
- (void)setUpNameLabel {
    _nameLabel = [[UILabel alloc] init];
    //获取当前登录用户呢称
    JMSGUser *user = [JMSGUser myInfo];
    JMSGUserInfo *userInfo = [[JMSGUserInfo alloc] init];
    if (userInfo.nickname) {
        _nameLabel.text = userInfo.nickname;
    }else {
        _nameLabel.text = user.username;
    }
    [_iconView addSubview:_nameLabel];
    _nameLabel.sd_layout
    .leftSpaceToView(self.iconImageView, 20)
    .widthIs(160)
    .heightIs(60)
    .topEqualToView(_iconImageView);
    //给label添加点击事件
    UITapGestureRecognizer *labelTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLabelClick)];
    // 2. 将点击事件添加到label上
    [_nameLabel addGestureRecognizer:labelTapGestureRecognizer];
    _nameLabel.userInteractionEnabled = YES; // 可以理解为设置label可被点击

}
#pragma mark - 初始化签名跳转按钮
- (void)setUpAutographLabelSelectButton {
    _autographLabelSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_autographLabelSelectButton setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
    [_autographLabelSelectButton addTarget:self action:@selector(clickautographLabelSelectButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:_autographLabelSelectButton];
    _autographLabelSelectButton.sd_layout
    .topSpaceToView(self.genderLabel, 43)
    .rightSpaceToView(self.cardView, 20)
    .widthIs(30)
    .heightIs(30);
    //根据button的tag来判断要修改的是签名框
    _autographLabelSelectButton.tag = 1;
}
#pragma mark - 初始化签名输入框
- (void)setUpFillAutographLabel {
    _fillAutographLabel = [[UILabel alloc] init];
    [_cardView addSubview:_fillAutographLabel];
    _fillAutographLabel.numberOfLines = 0;
    _fillAutographLabel.sd_layout
    .rightSpaceToView(_autographLabelSelectButton,10)
    .topSpaceToView(_fillGenderLabel, 30)
    .widthIs(155)
    .heightIs(150);
}
#pragma mark - 点击签名跳转按钮
- (void)clickautographLabelSelectButton {
    //通知修改的是签名框
    infoindex = _autographLabelSelectButton.tag;
    changeInfoViewController *changeInfoVc = [[changeInfoViewController alloc] init];
    [self.navigationController pushViewController:changeInfoVc animated:YES];
}
#pragma mark - 点击呢称框
- (void)nameLabelClick {
    changeInfoViewController *changeInfoVc = [[changeInfoViewController alloc] init];
    [self.navigationController pushViewController:changeInfoVc animated:YES];
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
#pragma mark - 初始化点击性别选择按钮
- (void)setUpGenderSelectButton {
    _genderSelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_genderSelectButton setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
    [_genderSelectButton addTarget:self action:@selector(clickgenderSelectButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:_genderSelectButton];
    _genderSelectButton.sd_layout
    .topSpaceToView(self.cardView, 25)
    .rightSpaceToView(self.cardView, 20)
    .widthIs(30)
    .heightIs(30);
}
#pragma mark - 初始化性别填写框
- (void)seuUpFillGenderLabel {
    _fillGenderLabel = [[UILabel alloc] init];
    [_cardView addSubview:_fillGenderLabel];
    _fillGenderLabel.sd_layout
    .rightSpaceToView(_genderSelectButton, 10)
    .widthIs(50)
    .heightIs(60)
    .topSpaceToView(_birthdayLabel, 30);
}
#pragma mark - 初始化点击性别选择按钮方法
- (void)clickBirthdaySelectButton {
    SexPickerTool *sexPick = [[SexPickerTool alloc] init];
    __block SexPickerTool *blockPicker = sexPick;
    sexPick.callBlock = ^(NSString *pickDate) {
        self->_fillGenderLabel.text= pickDate;
        if (pickDate) {
        }
        [blockPicker removeFromSuperview];
    };
    [self.cardView addSubview:sexPick];
    blockPicker.sd_layout
    .leftEqualToView(self.cardView)
    .rightEqualToView(self.cardView)
    .topEqualToView(self.dividingLine2)
    .heightIs(125);
}
#pragma mark - 初始化生日选择按钮
- (void)setUpBirthdaySelectButton {
    _birthdaySelectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_birthdaySelectButton setImage:[UIImage imageNamed:@"右箭头"] forState:UIControlStateNormal];
    [_birthdaySelectButton addTarget:self action:@selector(clickBirthdaySelectButton) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:_birthdaySelectButton];
    _birthdaySelectButton.sd_layout
    .topSpaceToView(self.birthdayLabel, 45)
    .rightSpaceToView(self.cardView, 20)
    .widthIs(30)
    .heightIs(30);
}
#pragma mark - 初始化生日填写框
- (void)setUpFillBirthdayLabel {
    _fillBirthdayLabel = [[UILabel alloc] init];
    [_cardView addSubview:_fillBirthdayLabel];
    _fillBirthdayLabel.sd_layout
    .rightSpaceToView(_birthdaySelectButton, 10)
    .widthIs(100)
    .heightIs(60)
    .topSpaceToView(_cardView, 10);
}
#pragma mark - 初始化点击生日选择按钮方法
- (void)clickgenderSelectButton {
    DatePickerTool *datePicker = [[DatePickerTool alloc] init];
    __block DatePickerTool *blockPick = datePicker;
    datePicker.callBlock = ^(NSString *pickDate) {
        self->_fillBirthdayLabel.text = pickDate;
        if (pickDate) {
        }
        [blockPick removeFromSuperview];
    };
    [self.cardView addSubview:datePicker];
    datePicker.sd_layout
    .leftEqualToView(self.cardView)
    .rightEqualToView(self.cardView)
    .topEqualToView(self.dividingLine1)
    .heightIs(200);
    
}
#pragma mark - 通知调用的方法
- (void)infoChange:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    NSNumber *index = dict[@"infoindex"];
    int intindex = [index intValue];
    if (intindex) {
        _fillAutographLabel.text = dict[@"infoTextFieldText"];
    }else {
        _nameLabel.text = dict[@"infoTextFieldText"];
    }
}
#pragma mark - 点击修改头像
- (void)changeIcon {
    //拿到获取相册的权限
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        UIImagePickerController *pic = [[UIImagePickerController alloc] init];
        pic.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        pic.delegate = self;
        [self presentViewController:pic animated:YES completion:nil];
    }
}

//点击相片后会跑这个方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //拿到图片会就销毁之前的控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    //info中就是包含你在相册里面选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _iconImageView.image = image;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
