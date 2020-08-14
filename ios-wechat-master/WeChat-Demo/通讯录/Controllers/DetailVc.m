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
#import "ChatController.h"
@interface DetailVc ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation DetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
   
    
    //同步滑动
    UIScrollView *scrView = [[UIScrollView alloc]init];
    scrView.contentSize = CGSizeMake(self.view.width, [UIScreen mainScreen].bounds.size.height-120);
    scrView.showsVerticalScrollIndicator = NO;
    scrView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrView];
    scrView.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    
    
    //头像
    __block UIImageView *headView = [[UIImageView alloc]init];
    [scrView addSubview:headView];
    headView.sd_layout.topSpaceToView(scrView, 20).leftSpaceToView(scrView, 30).widthIs(85).heightIs(85);
    [self.user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (data == nil) {
             headView.image = [UIImage imageNamed:@"未知头像"];
        }else{
             headView.image = [UIImage imageWithData:data];
        }
    }];
   
   
    
    
    //昵称
    _Name = [[UILabel alloc]init];
    if (self.user.noteName.length != 0 ) {//优先显示备注名、然后是昵称、最后是用户名
        _Name.text = [NSString stringWithFormat:@"%@",self.user.noteName];
    }else{
        if (self.user.nickname.length != 0) {//判断有无昵称
             _Name.text = [NSString stringWithFormat:@"%@",self.user.nickname];
        }else{
             _Name.text = [NSString stringWithFormat:@"%@",self.user.username];
        }
    }
    _Name.font = [UIFont systemFontOfSize:25];
    [scrView addSubview:_Name];
    _Name.sd_layout.topSpaceToView(scrView, 20).leftSpaceToView(headView, 25).heightIs(35).maxWidthIs(300);
    [_Name setSingleLineAutoResizeWithMaxWidth:300];
    
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
    [scrView addSubview:gender];
    gender.sd_layout.topSpaceToView(scrView, 25).leftSpaceToView(_Name, 10).heightIs(25).widthIs(25);
    
    //微信号（uid）
    UILabel *uid = [[UILabel alloc]init];
    uid.text = [NSString stringWithFormat:@"微信号:%lld",self.user.uid];
    uid.font = [UIFont systemFontOfSize:15];
    uid.textColor = [UIColor grayColor];
    [scrView addSubview:uid];
    uid.sd_layout.topSpaceToView(_Name, 3).leftSpaceToView(headView, 25).heightIs(20).maxWidthIs(300);
    [uid setSingleLineAutoResizeWithMaxWidth:300];
    
    //地区
    UILabel *region = [[UILabel alloc]init];
    region.text = self.user.region;//
    region.font = [UIFont systemFontOfSize:15];
    region.textColor = [UIColor grayColor];
    [scrView addSubview:region];
    region.sd_layout.topSpaceToView(uid, 3).leftSpaceToView(headView, 25).heightIs(20).maxWidthIs(300);
    [region setSingleLineAutoResizeWithMaxWidth:300];
    
    //备注标签、朋友权限、朋友圈、更多信息、发信息 的tableview
    if(_user.isFriend){
        _tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _tab.dataSource = self;
        _tab.tableFooterView = [[UIView alloc]init];
        _tab.delegate = self;
        [scrView addSubview:_tab];
        _tab.sd_layout.topSpaceToView(headView, 25).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
        _tab.sectionHeaderHeight = 0;
        _tab.sectionFooterHeight = 5;
        _tab.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,0.0f,_tab.bounds.size.width,0.01f)];
        _tab.scrollEnabled = NO;
        
        //导航条右按钮
        UIButton *rightBtn = [[UIButton alloc]init];
        [rightBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnWay) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    }else{}
    
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
            __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
            __block ChatController *chatController = [[ChatController alloc]init];
            [JMSGConversation createSingleConversationWithUsername:self.user.username completionHandler:^(id resultObject, NSError *error) {
                JMSGConversation *conversation = resultObject ;
                [conversation allMessages:^(id resultObject, NSError *error) {
                    array = resultObject;
                    chatController = [[ChatController alloc]initWithMsg:array];
                    chatController.hidesBottomBarWhenPushed = YES;
                    chatController.title = conversation.title;
                    chatController.otherSide = conversation.title;
                    chatController.conModel = conversation;
                    [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
                        chatController.otherIcon = data;
                     }];
                    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
                    [self.navigationItem setBackBarButtonItem:backItem];
                    [self.navigationController pushViewController:chatController animated:YES];
                }];
            }];
        }else{//音视频通话
           
        }
    }
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"朋友权限";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if(indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"朋友圈";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            cell.textLabel.text = @"更多信息";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
