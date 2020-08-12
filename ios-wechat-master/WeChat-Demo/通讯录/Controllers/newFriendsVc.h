//
//  newFriendsVc.h
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>

NS_ASSUME_NONNULL_BEGIN

@interface newFriendsVc : UIViewController
//数组模型
@property (nonatomic,strong) NSMutableArray *userModelArray;
@property (nonatomic,strong) UITableView *tab;
//当前登陆用户
@property (nonatomic,strong) JMSGUser *user;
@end

NS_ASSUME_NONNULL_END
