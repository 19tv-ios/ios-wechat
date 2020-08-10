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

    self.view.backgroundColor = [UIColor whiteColor];
    
    //获取当前登陆的用户信息
    self.user = [JMSGUser myInfo];
    
    //添加好友用户名
    self.nameTextField = [[UITextField alloc]init];
    self.nameTextField.placeholder = @"用户名";
    self.nameTextField.layer.masksToBounds =YES;
    self.nameTextField.layer.cornerRadius = 7;
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    self.nameTextField.attributedPlaceholder = [NSAttributedString.alloc initWithString:@"用户名"
                                                                               attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];//占位符水平居中
    self.nameTextField.layer.borderWidth = 1.0f;
    self.nameTextField.layer.borderColor = [UIColor grayColor].CGColor;
    self.nameTextField.delegate =  self;
    [self.view addSubview:self.nameTextField];
    self.nameTextField.sd_layout.topSpaceToView(self.view, 135).leftSpaceToView(self.view, 125).widthIs(185).heightIs(40);
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"用户名";
    [self.view addSubview:nameLabel];
    nameLabel.sd_layout.topSpaceToView(self.view, 135).leftSpaceToView(self.view, 30).widthIs(85).heightIs(40);
    
    
    //添加原因
    self.reasonTextField = [[UITextField alloc]init];
//    self.reasonTextField.placeholder = @"添加原因";
//    self.reasonTextField.placeholder
    self.reasonTextField.layer.masksToBounds = YES;
    self.reasonTextField.layer.cornerRadius = 7;
    self.reasonTextField.attributedPlaceholder = [NSAttributedString.alloc initWithString:@"添加原因"
                                                                         attributes:@{NSParagraphStyleAttributeName:paragraphStyle}];//占位符水平居中
    self.reasonTextField.layer.borderWidth = 1.0f;
    self.reasonTextField.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:self.reasonTextField];
    self.reasonTextField.sd_layout.topSpaceToView(self.nameTextField, 40).leftSpaceToView( self.view, 125).widthIs(185).heightIs(200);
    
    UILabel *reasonLabel = [[UILabel alloc]init];
    reasonLabel.text = @"添加原因";
    [self.view addSubview:reasonLabel];
    reasonLabel.sd_layout.topSpaceToView(self.nameTextField, 120).leftSpaceToView(self.view, 25).widthIs(90).heightIs(40);
    
    //添加按钮
    self.addBtn = [[UIButton alloc]init];
    [self.addBtn setTitle:@"添加到通讯录" forState:UIControlStateNormal];
    self.addBtn.layer.masksToBounds = YES;
    self.addBtn.layer.cornerRadius = 7;
    self.addBtn.layer.borderWidth = 1.0f;
    self.addBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    [self.addBtn setTitleColor: [UIColor colorWithRed:92.0f/255.0f green:102.0f/255.0f blue:138.0f/255.0f alpha:10]  forState:UIControlStateNormal];
    [self.view addSubview:self.addBtn];
    self.addBtn.sd_layout.topSpaceToView(self.reasonTextField, 80).leftSpaceToView(self.view, 113).widthIs(150).heightIs(40);
    [self.addBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark 监听
- (void)addFriends{
    
    NSString *nameStr = self.nameTextField.text;
    NSString *resonStr = self.reasonTextField.text;
    
    NSLog(@"name:%@",nameStr);
    NSLog(@"reson:%@",resonStr);
    
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
            NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            if (array == nil) {
                array = [NSMutableArray arrayWithCapacity:0];
            }
            [array addObject:self.user];
            
            NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:array];
            [data1 writeToFile:filePath atomically:YES];
            //发送完好友请求后返回通讯录页面
            AddressViewController *Vc = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:Vc animated:YES];
        }
        
    }];
    
    
    
    
}

@end
