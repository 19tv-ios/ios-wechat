//
//  DetailVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "DetailVc.h"
#import "SDAutoLayout.h"
#import "RemarkVc.h"
#import "SettingVc.h"
#import "MoreMessageVc.h"
@interface DetailVc ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //导航条右按钮
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnWay) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    //头像
    UIImageView *headView = [[UIImageView alloc]init];
//    headView.backgroundColor = [UIColor blueColor];
    __block UIImage *thumImage = [[UIImage alloc]init];
    [self.user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        thumImage = [UIImage imageWithData:data];
        headView.image = thumImage;
    }];
    if (headView.image == nil) {
        headView.image = [UIImage imageNamed:@"微信"];
    }
    [self.view addSubview:headView];
    headView.sd_layout.topSpaceToView(self.view, 110).leftSpaceToView(self.view, 30).widthIs(85).heightIs(85);
    
    //昵称
    UILabel *nickName = [[UILabel alloc]init];
    if (self.user.nickname == nil) {
        nickName.text = self.user.username;
    }else{
        nickName.text = self.user.nickname;
    }
//    nickName.backgroundColor = [UIColor yellowColor];
    nickName.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:nickName];
    nickName.sd_layout.topSpaceToView(self.view, 110).leftSpaceToView(headView, 25).heightIs(35).maxWidthIs(300);
    [nickName setSingleLineAutoResizeWithMaxWidth:300];
    
    //性别
    UIImageView *gender = [[UIImageView alloc]init];
    NSLog(@"%lu",self.user.gender);
    if (self.user.gender == 0) {
        gender.image = [UIImage imageNamed:@"未知"];
    }else if (self.user.gender == 1){
        gender.image = [UIImage imageNamed:@"性别男"];
    }else{
        gender.image = [UIImage imageNamed:@"性别女"];
    }
    [self.view addSubview:gender];
    gender.sd_layout.topSpaceToView(self.view, 115).leftSpaceToView(nickName, 10).heightIs(25).widthIs(25);
    
    //微信号（uid）
    UILabel *uid = [[UILabel alloc]init];
    uid.text = [NSString stringWithFormat:@"微信号:%lld",self.user.uid];
    uid.font = [UIFont systemFontOfSize:15];
    uid.textColor = [UIColor grayColor];
    [self.view addSubview:uid];
    uid.sd_layout.topSpaceToView(nickName, 3).leftSpaceToView(headView, 25).heightIs(20).maxWidthIs(300);
    [uid setSingleLineAutoResizeWithMaxWidth:300];
    
    //地区
    UILabel *region = [[UILabel alloc]init];
    region.text = self.user.region;//
    region.font = [UIFont systemFontOfSize:15];
    region.textColor = [UIColor grayColor];
    [self.view addSubview:region];
    region.sd_layout.topSpaceToView(uid, 3).leftSpaceToView(headView, 25).heightIs(20).maxWidthIs(300);
    [region setSingleLineAutoResizeWithMaxWidth:300];
    
    //备注标签、朋友权限、朋友圈、更多信息、发信息 的tableview
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    tab.dataSource = self;
    tab.tableFooterView = [[UIView alloc]init];
    tab.delegate = self;
    [self.view addSubview:tab];
    tab.sd_layout.topSpaceToView(headView, 25).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    tab.sectionHeaderHeight = 0;
    tab.sectionFooterHeight = 5;
    tab.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,tab.bounds.size.width,0.01f)];
    


}


#pragma mark 监听
//右上角设置按钮
- (void)rightBtnWay{
    SettingVc *Vc = [[SettingVc alloc]init];
    Vc.user = self.user;
    [self.navigationController pushViewController:Vc animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//跳转备注控制器
            RemarkVc *Vc = [[RemarkVc alloc]init];
            Vc.user = self.user;
            [self.navigationController pushViewController:Vc animated:YES];
        }else{//朋友权限
            
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {//朋友圈
           
        }else{//更多信息
            MoreMessageVc *Vc = [[MoreMessageVc alloc]init];
            Vc.user = self.user;
            [self.navigationController pushViewController:Vc animated:YES];
        }
    }else{
        if (indexPath.row == 0) {//发消息
           
        }else{//音视频通话
           
        }
    }
}
#pragma mark tableview datasoure
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"备注和标签";
        }else{
            cell.textLabel.text = @"朋友权限";
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"朋友圈";
        }else{
            cell.textLabel.text = @"更多信息";
        }
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"发信息";
            cell.textLabel.textColor = [UIColor colorWithRed:92.0f/255.0f green:102.0f/255.0f blue:138.0f/255.0f alpha:10];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
        }else{
            cell.textLabel.text = @"音视频通话";
            cell.textLabel.textColor = [UIColor colorWithRed:92.0f/255.0f green:102.0f/255.0f blue:138.0f/255.0f alpha:10];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;//文字居中
        }
    }
    
    return cell;
}


@end
