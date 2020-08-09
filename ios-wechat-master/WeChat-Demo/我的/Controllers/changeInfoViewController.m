//
//  changeInfoViewController.m
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/7.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "changeInfoViewController.h"
#import "SDAutoLayout.h"

@interface changeInfoViewController ()

//初始化输入框
@property (nonatomic, strong) UITextField *infoTextField;
@end

//用来判断修改的是不是签名框
extern NSInteger infoindex;
//用来判断修改的是不是密码
extern NSInteger passwordindex;

@implementation changeInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"完成"] style:0 target:self action:@selector(complete)];
    
    //初始化输入框
    [self setUpInfoTextField];
}

#pragma mark - 初始化信息输入框
- (void)setUpInfoTextField {
    _infoTextField = [[UITextField alloc] init];
    _infoTextField.placeholder = @"Info";
    _infoTextField.layer.borderWidth=1.0f;
    _infoTextField.layer.cornerRadius=5.0;
    _infoTextField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _infoTextField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _infoTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    _infoTextField.leftViewMode=UITextFieldViewModeAlways;
    _infoTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_infoTextField];
    _infoTextField.sd_layout
    .topSpaceToView(self.navigationController.navigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(42);
}

#pragma mark - 点击完成按钮
- (void)complete {
    if (_infoTextField.hasText) {
        //通知传修改的内容
        NSNumber *index = [NSNumber numberWithInteger:infoindex];
        int intindex = [index intValue];
        NSNumber *passindex = [NSNumber numberWithInteger:passwordindex];
        int intpassindex = [passindex intValue];
        NSStringEncoding enc =   CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        NSData *data = [_infoTextField.text dataUsingEncoding:enc];
        NSInteger dataLen = data.length;
        //字节限制
        if (intindex) {
            if (dataLen>120) {
                NSString *string = @"签名框的最大字节数为120.请重新输入";
                [self showAlert:string];
            }else {
                NSDictionary *dict = @{
                                       @"infoTextFieldText":_infoTextField.text,
                                       @"infoindex":index
                                       };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"infoChange" object:nil userInfo:dict];
                infoindex = 0;
                [self.navigationController popViewControllerAnimated:YES];
            }
        }else {
            if (dataLen>15) {
                NSString *string = @"最大字节数为15.请重新输入";
                [self showAlert:string];
            }else {
                if (intpassindex) {
                    
                    NSDictionary *dict = @{
                                           @"infoTextFieldText":_infoTextField.text,
                                           @"infoindex":passindex
                                           };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoChange" object:nil userInfo:dict];
                    passwordindex = 0;
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    NSDictionary *dict = @{
                                           @"infoTextFieldText":_infoTextField.text,
                                           @"infoindex":index
                                           };
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"infoChange" object:nil userInfo:dict];
                    infoindex = 0;
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
