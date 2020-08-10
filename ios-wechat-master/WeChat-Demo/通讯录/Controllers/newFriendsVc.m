//
//  newFriendsVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "newFriendsVc.h"
#import <JMessage/JMessage.h>
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
    
    //添加监听代理
    [JMessage addDelegate:self withConversation:nil];
    
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
//    NSString *str = [NSString stringWithFormat:@"%ld",btn.tag];
    NSString *UserName = btn.user.username;
    [JMSGFriendManager acceptInvitationWithUsername:UserName appKey:@"0a974aa68871f642444ae38b" completionHandler:^(id resultObject, NSError *error) {
        NSLog(@"error:%@",error);
        AddressViewController *Vc = self.navigationController.viewControllers[0];
        [Vc updateFriendsList];
        [self.navigationController popToViewController:Vc animated:YES];
    }];
}
# pragma mark datasource
//多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//self.nameSectionsArray.count
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
    [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
    }];
    cell.textLabel.text = user.username;//user.nickname
    
    Zhbutton *agreeBtn = [[Zhbutton alloc]init];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    
    [agreeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    agreeBtn.backgroundColor = [UIColor colorWithRed:120.0f/255.0f green:194.0f/255.0f blue:109.0f/255.0f alpha:1];
 
    agreeBtn.user = user;
    [agreeBtn addTarget:self action:@selector(agreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:agreeBtn];
    agreeBtn.sd_layout.topEqualToView(cell.contentView).leftSpaceToView(cell.contentView, 325).widthIs(40).heightIs(45);
    [agreeBtn sizeToFit];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    DetailVc *Vc = [[DetailVc alloc]init];
    Vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:Vc animated:YES];
    NSLog(@"%ld---%ld",indexPath.section,indexPath.row);
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

@end
