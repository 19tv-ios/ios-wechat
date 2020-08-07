//
//  AddFriendsVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "AddFriendsVc.h"

@interface AddFriendsVc ()<UITextFieldDelegate>
//添加好友用户名
@property (nonatomic,strong) UITextField *nameTextField;
//添加按钮
@property (nonatomic,strong) UIButton *addBtn;
//添加原因
@property (nonatomic,strong) UITextField *resonTextField;

@end

@implementation AddFriendsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加好友用户名
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.placeholder = @"用户名";
    self.nameTextField.layer.borderWidth = 1.0f;
    self.nameTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.nameTextField.delegate =  self;
    [self.view addSubview:self.nameTextField];
    self.nameTextField.sd_layout.topSpaceToView(self.view, 130).leftSpaceToView( self.view, 96).widthIs(185).heightIs(40);
    
    //添加原因
    self.resonTextField = [[UITextField alloc]init];
    self.resonTextField.placeholder = @"添加原因";
    self.resonTextField.layer.borderWidth = 1.0f;
    self.resonTextField.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:self.resonTextField];
    self.resonTextField.sd_layout.topSpaceToView(self.nameTextField, 40).leftSpaceToView( self.view, 96).widthIs(185).heightIs(200);
    
    //添加按钮
    self.addBtn = [[UIButton alloc]init];
    [self.addBtn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    [self.addBtn setTitleColor: [UIColor colorWithRed:92.0f/255.0f green:102.0f/255.0f blue:138.0f/255.0f alpha:10]  forState:UIControlStateNormal];
    [self.view addSubview:self.addBtn];
    self.addBtn.sd_layout.topSpaceToView(self.resonTextField, 80).leftSpaceToView(self.view, 113).widthIs(150).heightIs(40);
    [self.addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 监听
- (void)addFriends{
    
    NSString *nameStr = self.nameTextField.text;
    NSString *resonStr = self.resonTextField.text;
    
    NSLog(@"name:%@",nameStr);
    NSLog(@"reson:%@",resonStr);
    
    [JMSGFriendManager sendInvitationRequestWithUsername:nameStr appKey: @"0a974aa68871f642444ae38b" reason:resonStr completionHandler:^(id resultObject, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    self.nameStr = textField.text;
//}

@end
