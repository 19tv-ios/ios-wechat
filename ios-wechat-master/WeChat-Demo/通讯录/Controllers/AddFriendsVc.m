//
//  AddFriendsVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "AddFriendsVc.h"
#import "AddressViewController.h"

@interface AddFriendsVc ()<UITextFieldDelegate>
//添加好友用户名
@property (nonatomic,strong) UITextField *nameTextField;
//添加按钮
@property (nonatomic,strong) UIButton *addBtn;
//添加原因
@property (nonatomic,strong) UITextField *reasonTextField;

@end

@implementation AddFriendsVc

- (void)viewDidLoad {
    [super viewDidLoad];

     self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    //获取当前登陆的用户信息
    self.user = [JMSGUser myInfo];
    
    //添加好友用户名
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.placeholder = @"用户名";
    self.nameTextField.layer.masksToBounds =YES;
    self.nameTextField.layer.cornerRadius = 5;
    _nameTextField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    self.nameTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    self.nameTextField.leftViewMode=UITextFieldViewModeAlways;
    self.nameTextField.layer.borderWidth = 1.0f;
    self.nameTextField.delegate =  self;
    _nameTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.nameTextField];
    self.nameTextField.sd_layout
    .topSpaceToView(self.navigationController.navigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .heightIs(40)
    .rightEqualToView(self.view);
    
    
    //添加原因
    self.reasonTextField = [[UITextField alloc]init];
    self.reasonTextField.placeholder = @"添加原因";
    self.reasonTextField.layer.masksToBounds = YES;
    self.reasonTextField.layer.cornerRadius = 5;
    self.reasonTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
    self.reasonTextField.leftViewMode=UITextFieldViewModeAlways;
    self.reasonTextField.layer.borderWidth = 1.0f;
    _reasonTextField.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _reasonTextField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.reasonTextField];
    self.reasonTextField.sd_layout.
    topSpaceToView(self.nameTextField, 18)
    .leftSpaceToView(self.view, 0)
    .heightIs(40)
    .rightEqualToView(self.view);
    
   
    
    //添加按钮
    self.addBtn = [[UIButton alloc]init];
    [self.addBtn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 5;
    self.addBtn.layer.borderWidth = 1.0f;
    self.addBtn.layer.borderColor = [UIColor grayColor].CGColor;
    self.addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.addBtn setTitleColor: [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]  forState:UIControlStateNormal];
    _addBtn.layer.borderColor=[UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    self.addBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.addBtn];
    self.addBtn.sd_layout
    .topSpaceToView(self.reasonTextField, 15)
    .leftSpaceToView(self.view, 0)
    .rightEqualToView(self.view)
    .heightIs(40);
    [self.addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 监听
- (void)addFriends{
    
    NSString *nameStr = self.nameTextField.text;
    NSString *resonStr = self.reasonTextField.text;
    
    if (self.nameTextField.hasText) {
        //发送好友请求
        [JMSGFriendManager sendInvitationRequestWithUsername:nameStr appKey: @"0a974aa68871f642444ae38b" reason:resonStr completionHandler:^(id resultObject, NSError *error) {
            if (error != nil) {
                UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"你已经添加过该好友" message:nil preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                [AlertController addAction:agreeAction];
                [self.navigationController presentViewController:AlertController animated:YES completion:nil];
            }else{
                //本地储存历史添加请求
                NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
                NSString *filePath = [path stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@userModelArray.plist",nameStr]];
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                NSMutableArray *userModelArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                if (userModelArray == nil) {
                    userModelArray = [NSMutableArray arrayWithCapacity:0];
                }
                [userModelArray addObject:self.user];
                
                NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:userModelArray];
                [data1 writeToFile:filePath atomically:YES];
                //发送完好友请求后返回通讯录页面
                AddressViewController *Vc = self.navigationController.viewControllers[0];
                [self.navigationController popToViewController:Vc animated:YES];
            }
            
        }];
    }else {
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"请填写有效信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [AlertController addAction:agreeAction];
        [self.navigationController presentViewController:AlertController animated:YES completion:nil];
    }
    
}

@end
