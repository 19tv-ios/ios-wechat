//
//  newFriendsVc.h
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface newFriendsVc : UIViewController
//数组模型
@property (nonatomic,strong) NSMutableArray *userModelArray;
@property (nonatomic,strong) UITableView *tab;
@end

NS_ASSUME_NONNULL_END
