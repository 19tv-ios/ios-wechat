//
//  SettingVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/8.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "SettingVc.h"
#import "SDAutoLayout.h"
#import "RemarkVc.h"
#import "AddressViewController.h"
@interface SettingVc ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SettingVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"资料设置";
    
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 9, 0) style:UITableViewStyleGrouped];
    tab.tableFooterView = [[UIView alloc]init];
    tab.sectionFooterHeight = 5;
    tab.dataSource = self;
    tab.delegate = self;
    [self.view addSubview:tab];
    tab.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    

}

#pragma mark datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"备注和标签";
        }else{
            cell.textLabel.text = @"朋友权限";
        }
    }else if (indexPath.section == 1){
        UISwitch *Switch = [[UISwitch alloc]init];
        cell.accessoryView = Switch;
        Switch.on = self.user.isNoDisturb;
        [Switch addTarget:self action:@selector(DistubWay:) forControlEvents:UIControlEventTouchUpInside];
        cell.textLabel.text = @"消息免打扰";
    }else if (indexPath.section == 2){
        UISwitch *Switch = [[UISwitch alloc]init];
        cell.accessoryView = Switch;
        Switch.on = self.user.isInBlacklist;
        [Switch addTarget:self action:@selector(BlacklistWay:) forControlEvents:UIControlEventTouchUpInside];
        cell.textLabel.text = @"加入黑名单";
    }else{
        cell.textLabel.text = @"删除";
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    
    return cell;
}
#pragma mark 监听
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            RemarkVc *Vc = [[RemarkVc alloc]init];
            Vc.user = self.user;
            [self.navigationController pushViewController:Vc animated:YES];
        }
       
    }else if (indexPath.section == 1){//消息免打扰
        
    }else if (indexPath.section == 2){//加入黑名单
        
    }else{//删除好友
        UIAlertController *AlertController = [UIAlertController alertControllerWithTitle:@"确定删除该好友吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [JMSGFriendManager removeFriendWithUsername:self.user.username appKey:@"0a974aa68871f642444ae38b" completionHandler:^(id resultObject, NSError *error) {
                        if (error == nil) {NSLog(@"删除好友成功");}
                
                AddressViewController *Vc  = self.navigationController.viewControllers[0];
                [Vc updateFriendsList];
                [self.navigationController popToViewController:Vc animated:YES];
                    }];
        }];
        UIAlertAction *disagreeAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
        [AlertController addAction:agreeAction];
        [AlertController addAction:disagreeAction];
        [self presentViewController:AlertController animated:YES completion:nil];
    }
}

- (void)DistubWay:(UISwitch *)sender{
    [self.user setIsNoDisturb:sender.on handler:^(id resultObject, NSError *error) {
        if (sender.on == YES) {
            NSLog(@"设置免打扰成功");
        }else{
            NSLog(@"取消免打扰");
        }
    }];
}

- (void)BlacklistWay:(UISwitch *)sender{
    if (sender.on == YES) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:self.user.username];
        [JMSGUser addUsersToBlacklist:array completionHandler:^(id resultObject, NSError *error) {
            NSLog(@"error:%@",error);
            NSLog(@"添加黑名单成功");
        }];
    }else{
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        [array addObject:self.user.username];
        [JMSGUser delUsersFromBlacklist:array completionHandler:^(id resultObject, NSError *error) {
            NSLog(@"error:%@",error);
            NSLog(@"删除黑名单成功");
        }];
    }
}
@end
