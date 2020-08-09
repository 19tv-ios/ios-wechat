//
//  RemarkVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/8.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "RemarkVc.h"
#import "SDAutoLayout.h"
@interface RemarkVc ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
//右上角按钮
@property (nonatomic,strong) UIButton *rightBtn;
//备注名textfield
@property (nonatomic,strong) UITextField *textField;
@end

@implementation RemarkVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置备注和标签";
    
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
//    tab.tableFooterView = [[UIView alloc]init];
    tab.sectionFooterHeight = 5;
    tab.dataSource = self;
    tab.delegate = self;
    [self.view addSubview:tab];
    tab.sd_layout.topEqualToView(self.view).rightEqualToView(self.view).leftEqualToView(self.view).bottomEqualToView(self.view);
    
    //右上角完成按钮
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    _rightBtn.backgroundColor = [UIColor colorWithRed:226.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1];
    [_rightBtn setTitleColor: [UIColor colorWithRed:181.0f/255.0f green:181.0f/255.0f blue:181.0f/255.0f alpha:1] forState:UIControlStateNormal];
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
        _textField = [[UITextField alloc]init];
        _textField.delegate = self;
        if (self.user.noteName == nil) {
            _textField.placeholder = self.user.nickname;
        }else{
            _textField.text = self.user.nickname;
        }
        [cell.contentView addSubview:_textField];
        _textField.sd_layout.topEqualToView(cell.contentView).leftEqualToView(cell.contentView).rightEqualToView(cell.contentView).bottomEqualToView(cell.contentView);
    }else if (indexPath.section == 1){
        
    }else if (indexPath.section == 2){
        
    }else{
        UITextField *textField = [[UITextField alloc]init];
        if (self.user.noteText == nil) {
            textField.text = @"添加更多的备注信息";
            textField.delegate = self;
//            [textField  setValue:[UIColor  blackColor]forKeyPath:@"_placeholderLabel.textColor"];
        }else{
            textField.placeholder = @"添加更多的备注信息";
//            textField.text = self.user.noteText;
        }
        [cell.contentView addSubview:textField];
        textField.sd_layout.topEqualToView(cell.contentView).leftEqualToView(cell.contentView).rightEqualToView(cell.contentView).bottomEqualToView(cell.contentView);
    }
   
    
    return cell;
}


#pragma mark 监听
- (void)rightBtnWay{
    [self.user updateNoteName:self.textField.text completionHandler:^(id resultObject, NSError *error) {
        NSLog(@"修改成功备注名为:%@",self.textField.text);
    }];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _rightBtn.backgroundColor = [UIColor colorWithRed:120.0f/255.0f green:194.0f/255.0f blue:109.0f/255.0f alpha:1];
    [self.rightBtn setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
    
}
@end
