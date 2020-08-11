//
//  changeInfoViewController.m
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/7.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "changeInfoViewController.h"
#import "SDAutoLayout.h"


@interface changeInfoViewController ()<UITextFieldDelegate>

//初始化输入框
@property (nonatomic, strong) UITextField *infoTextField;

//初始化字符限制label
@property (nonatomic, strong) UILabel *strictLabel;

@property (assign,nonatomic) NSInteger maxLength;

@property (nonatomic, strong) UITextField *oldpassword;

@property (nonatomic, strong) UILabel *passwordTips;

@property (nonatomic, strong) UILabel *errorPassword;

@end


extern NSInteger infoindex;

extern NSString *infopassword;

@implementation changeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"完成"] style:0 target:self action:@selector(complete)];
    
    NSNumber *index = [NSNumber numberWithInteger:infoindex];
    int intindex = [index intValue];
    
    if (intindex == 3) {
        //初始化原密码输入框
        [self setUpOldPassWord];
        //原密码提示错误
        [self setUpErrorPasswprd];
    }
    //初始化输入框
    [self setUpInfoTextField];
    
    //初始化字符限制label
    [self setUpStrictLabel];
    
    if (intindex == 3) {
        //初始化密码Tips
        [self setUpPasswordTips];
    }
    
    
}
#pragma mark - 初始化原密码输入框
- (void)setUpOldPassWord {
    _oldpassword = [[UITextField alloc] init];
    _oldpassword.placeholder = @"请输入原密码";
    _oldpassword.delegate = self;
    _oldpassword.tag = 1;
    _oldpassword.layer.borderWidth=1.0f;
    _oldpassword.layer.cornerRadius=5.0;
    _oldpassword.clearButtonMode=UITextFieldViewModeWhileEditing;
    _oldpassword.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _oldpassword.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _oldpassword.leftViewMode=UITextFieldViewModeAlways;
    _oldpassword.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_oldpassword];
    _oldpassword.sd_layout
    .topSpaceToView(self.navigationController.navigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(42);
}
#pragma mark - 密码错误
- (void)setUpErrorPasswprd {
    _errorPassword = [[UILabel alloc] init];
    _errorPassword.text = @"原密码错误";
    _errorPassword.textAlignment = NSTextAlignmentCenter;
    _errorPassword.textColor = [UIColor redColor];
    _errorPassword.hidden = YES;
    [self.view addSubview:_errorPassword];
    _errorPassword.sd_layout
    .leftEqualToView(_oldpassword)
    .rightEqualToView(_oldpassword)
    .topSpaceToView(_oldpassword, 2)
    .heightIs(16);
}
#pragma mark - 初始化信息输入框
- (void)setUpInfoTextField {
    _infoTextField = [[UITextField alloc] init];
     _infoTextField.delegate = self;
    _infoTextField.tag = 2;
    NSNumber *index = [NSNumber numberWithInteger:infoindex];
    int intindex = [index intValue];
    if (intindex == 3) {
        _infoTextField.placeholder = @"请输入新密码";
    }else {
        _infoTextField.placeholder = @"Info";
    }
    _infoTextField.layer.borderWidth=1.0f;
    _infoTextField.layer.cornerRadius=5.0;
    _infoTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _infoTextField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _infoTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _infoTextField.leftViewMode=UITextFieldViewModeAlways;
    _infoTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_infoTextField];
    if (intindex == 3) {
        _infoTextField.sd_layout
        .topSpaceToView(_errorPassword, 3)
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(42);
    }else {
        _infoTextField.sd_layout
        .topSpaceToView(self.navigationController.navigationBar, 0)
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(42);
    }
    
}

#pragma mark - 点击完成按钮
- (void)complete {
    if (_infoTextField.hasText) {
        //通知传修改的内容
        NSNumber *index = [NSNumber numberWithInteger:infoindex];
        int intindex = [index intValue];
        if (intindex == 3) {
            if ([self checknotChinese:_infoTextField.text]&&[self checkStrLength:_infoTextField.text]&&[self isOldpassword:_oldpassword.text]) {
                NSDictionary *dict = @{
                                       @"infoTextFieldText":_infoTextField.text,
                                       @"infoindex":index
                                       };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"infoChange" object:nil userInfo:dict];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            NSDictionary *dict = @{
                                   @"infoTextFieldText":_infoTextField.text,
                                   @"infoindex":index
                                   };
            [[NSNotificationCenter defaultCenter] postNotificationName:@"infoChange" object:nil userInfo:dict];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - 提示框
- (void)showAlert:(NSString *) title {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
#pragma mark - 字符限制框
- (void)setUpStrictLabel {
    _strictLabel = [[UILabel alloc] init];
    NSNumber *index = [NSNumber numberWithInteger:infoindex];
    int intindex = [index intValue];
    if (intindex == 3) {
        _maxLength = 15;
    }else {
       _maxLength = 10;
    }
    _strictLabel.text = [NSString stringWithFormat:@"0/%ld",(long)_maxLength];
    _strictLabel.textColor = [UIColor blackColor];
    [_infoTextField addSubview:_strictLabel];
    _strictLabel.sd_layout
    .topSpaceToView(_infoTextField, 5)
    .rightSpaceToView(_infoTextField, 5)
    .widthIs(50)
    .heightIs(30);
    
}
#pragma mark - 初始化密码提示
- (void)setUpPasswordTips {
    _passwordTips = [[UILabel alloc] init];
    _passwordTips.text = @"密码不支持中文.而且最小长度为4";
    _passwordTips.textAlignment =  NSTextAlignmentCenter;
    _passwordTips.textColor = [UIColor grayColor];
    [self.view addSubview:_passwordTips];
    _passwordTips.sd_layout
    .leftEqualToView(_infoTextField)
    .rightEqualToView(_infoTextField)
    .topSpaceToView(_infoTextField, 5)
    .heightIs(40);
}
#pragma mark - UITextField的代理方法
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.tag == 2) {
        NSInteger tlength = string.length;
        if (range.location+tlength >self.maxLength) {
            return NO;
        }
        NSString * str = [_infoTextField.text stringByReplacingCharactersInRange:range withString:string];
        if (range.length == 1 && string.length == 0) {
            NSString * length = [NSString stringWithFormat:@"%ld/%ld",str.length,self.maxLength];
            _strictLabel.text = length;
            return YES;
        }
        else if (_strictLabel.text.length >= self.maxLength) {
            _strictLabel.text = [textField.text substringToIndex:self.maxLength];
            NSString * length = [NSString stringWithFormat:@"%ld/%ld",self.maxLength,self.maxLength];
            _strictLabel.text = length;
            return NO;
        }
        NSString * length = [NSString stringWithFormat:@"%ld/%ld",str.length,self.maxLength];
        self.strictLabel.text = length;
        return YES;
    }
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 1) {
        _errorPassword.hidden = YES;
    }
}
#pragma mark - 判断密码是否含有中文
- (BOOL)checknotChinese:(NSString *)string {
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            _passwordTips.textColor = [UIColor redColor];
            return NO;
        }
    }
    return YES;
}
#pragma mark - 判断密码的字节数
- (BOOL) checkStrLength:(NSString *)string {
    if (string.length< 4) {
        _passwordTips.textColor = [UIColor redColor];
        return NO;
    }
    return YES;
}
#pragma mark - 判断原密码正确
- (BOOL)isOldpassword:(NSString *)text {
    if ([text isEqualToString:infopassword]) {
         return YES;
    }
    _errorPassword.hidden = NO;
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
