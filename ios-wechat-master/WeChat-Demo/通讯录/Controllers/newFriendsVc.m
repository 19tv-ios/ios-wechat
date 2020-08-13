//
//  newFriendsVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "newFriendsVc.h"
#import "SDAutoLayout.h"
#import "DetailVc.h"
#import "Zhbutton.h"
#import "AddressViewController.h"
@interface newFriendsVc ()<JMessageDelegate,UITableViewDataSource,UITableViewDelegate>
//新的朋友数组
@property (nonatomic,strong) NSMutableDictionary *usernameDict;
@end
 static NSString* ID = @"user";

@implementation newFriendsVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.userModelArray == nil) {
        self.userModelArray = [NSMutableArray arrayWithCapacity:0];
    }
    
    if (self.usernameDict == nil) {
        self.usernameDict = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    self.tab = [[UITableView alloc]init];
    self.tab.dataSource = self;
    self.tab.delegate = self;
    self.tab.tableFooterView = [[UIView alloc]init];//隐藏多余的白线
    [self.view addSubview:self.tab];
    self.tab.sd_layout.topSpaceToView(self.view, 50).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    
    [self.tab reloadData];
    
}
#pragma mark 监听
- (void)agreeBtn:(Zhbutton *)btn{

    NSString *UserName = btn.user.username;
    [self.userModelArray removeObjectAtIndex:btn.row];
    //本地储存历史添加请求
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"path:%@",path);
    NSString *filePath = [path stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@userModelArray.plist",self.user.username]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.userModelArray];
    [data writeToFile:filePath atomically:YES];
    [JMSGFriendManager acceptInvitationWithUsername:UserName appKey:@"0a974aa68871f642444ae38b" completionHandler:^(id resultObject, NSError *error) {
        NSLog(@"error:%@",error);
        AddressViewController *Vc = self.navigationController.viewControllers[0];
        Vc.userModelArray = self.userModelArray;//更新未读消息
        [Vc updateFriendsList];
        [self.navigationController popToViewController:Vc animated:YES];
        
    }];
    
}
# pragma mark datasource
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.userModelArray.count;//array.count self.userModelArray.count
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }else{
        while ([cell.contentView.subviews lastObject] !=nil) {
            [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
        }
    }
    
    JMSGUser *user = self.userModelArray[indexPath.row];
    if (user.nickname == nil) {
        cell.textLabel.text = user.username;
    }else{
        cell.textLabel.text = user.nickname;

    }
    
    Zhbutton *agreeBtn = [[Zhbutton alloc]init];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [agreeBtn setTitleColor: [UIColor colorWithRed:21/255.0 green:126/255.0 blue:251/255.0 alpha:1.0]  forState:UIControlStateNormal];
    agreeBtn.backgroundColor = [UIColor whiteColor];
    agreeBtn.user = user;
    agreeBtn.row = indexPath.row;//第几个cell的同意按钮
    [agreeBtn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:agreeBtn];
    agreeBtn.sd_layout
    .topEqualToView(cell.contentView)
    .rightSpaceToView(cell.contentView, 5)
    .widthIs(40)
    .heightIs(45);
    
    cell.imageView.sd_layout.topSpaceToView(cell.contentView, 8).heightIs(30).widthIs(30);
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 5;
    if (cell.imageView.image == nil) {
        [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (data == nil) {
                cell.imageView.image = [UIImage imageNamed:@"未知头像"];
            }else{
                cell.imageView.image  = [UIImage imageWithData:data];
            }
            //刷新该行
            [self.tab reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }];
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailVc *Vc = [[DetailVc alloc]init];
    Vc.hidesBottomBarWhenPushed = YES;
    Vc.user = [_userModelArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:Vc animated:YES];
    NSLog(@"%ld---%ld",indexPath.section,indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
