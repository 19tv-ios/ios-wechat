//
//  RemarkVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/8.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "RemarkVc.h"
#import "SDAutoLayout.h"
#import "DetailVc.h"
#import "AddressViewController.h"
@interface RemarkVc ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//右上角按钮
@property (nonatomic,strong) UIButton *rightBtn;
//备注名textfield
@property (nonatomic,strong) UITextField *noteNameTextField;
//备注信息textfield
@property (nonatomic,strong) UITextField *noteTextField;
//tableview
@property (nonatomic,strong) UITableView *tab;
@end

@implementation RemarkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置备注和标签";
    
    _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _tab.sectionFooterHeight = 5;
    _tab.dataSource = self;
    _tab.delegate = self;
    [self.view addSubview:_tab];
    _tab.sd_layout.topEqualToView(self.view).rightEqualToView(self.view).leftEqualToView(self.view).bottomEqualToView(self.view);
    
    //右上角完成按钮
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    _rightBtn.enabled = NO;
//    [_rightBtn setTitleColor: [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]  forState:UIControlStateNormal];
    [_rightBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    _rightBtn.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
    [_rightBtn addTarget:self action:@selector(rightBtnWay) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightBtn];
    
}

#pragma mark datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//每个section的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"备注名";
    }else if (section == 1){
        return @"标签";
    }else if (section == 2){
        return @"电话号码";
    }else{
        return @"描述";
    }
    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        _noteNameTextField = [[UITextField alloc]init];
        _noteNameTextField.delegate = self;
        _noteNameTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
        _noteNameTextField.leftViewMode=UITextFieldViewModeAlways;

        if (self.user.noteName.length == 0) {
            _noteNameTextField.placeholder = self.user.nickname;
        }else{
            _noteNameTextField.text = self.user.noteName;
        }
        [cell.contentView addSubview:_noteNameTextField];
        _noteNameTextField.sd_layout.topEqualToView(cell.contentView).leftEqualToView(cell.contentView).rightEqualToView(cell.contentView).bottomEqualToView(cell.contentView);
    }else if (indexPath.section == 1){
        
    }else if (indexPath.section == 2){
        
    }else{
        _noteTextField = [[UITextField alloc]init];
        if (self.user.noteText.length == 0) {
            _noteTextField.placeholder = @"添加更多的备注信息";
            _noteTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
            _noteTextField.leftViewMode=UITextFieldViewModeAlways;
            _noteTextField.delegate = self;
        }else{
            _noteTextField.text = self.user.noteText;
            _noteTextField.leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 51)];
            _noteTextField.leftViewMode=UITextFieldViewModeAlways;
            _noteTextField.delegate = self;
        }
        [cell.contentView addSubview:_noteTextField];
        _noteTextField.sd_layout.topEqualToView(cell.contentView).leftEqualToView(cell.contentView).rightEqualToView(cell.contentView).bottomEqualToView(cell.contentView);
    }
   
    
    return cell;
}


#pragma mark 监听
- (void)rightBtnWay{
    if ([self.noteNameTextField.text isEqualToString:self.user.noteName]) {
        
    }else{
        [self.user updateNoteName:self.noteNameTextField.text completionHandler:^(id resultObject, NSError *error) {
            self.user = resultObject;
            NSLog(@"修改成功备注名为:%@",self.user.noteName);
            DetailVc *Vc = self.navigationController.viewControllers[1];
            Vc.Name.text = self.user.noteName;
            [self.tab reloadData];
            AddressViewController *AddVc = self.navigationController.viewControllers[0];
            [AddVc updateFriendsList];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
   
    if ([self.noteTextField.text isEqualToString:self.user.noteText] ) {
        
    }else{
        [self.user updateNoteText:self.noteTextField.text completionHandler:^(id resultObject, NSError *error) {
            if (self.noteTextField.text.length != 0) {
                self.user = resultObject;
                NSLog(@"修改成功备注信息为:%@",self.user.noteText);
                [self.navigationController popViewControllerAnimated:YES];
            }else{}
        }];
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _rightBtn.enabled = YES;
    [_rightBtn setTitleColor: [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]  forState:UIControlStateNormal];

}


@end
