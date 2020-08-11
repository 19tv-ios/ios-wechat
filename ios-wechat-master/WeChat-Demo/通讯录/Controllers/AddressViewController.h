//
//  AddressViewController.h
//  demo
//
//  Created by fu00 on 2020/8/7.
//  Copyright © 2020 fu00. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressViewController : UIViewController
//uitableview通讯录好友
@property (nonatomic,strong) UITableView *tableView;
//新的朋友请求的数组模型
@property (nonatomic,strong) NSMutableArray *userModelArray;
- (void)updateFriendsList;//更新通讯录页面
@end

NS_ASSUME_NONNULL_END
