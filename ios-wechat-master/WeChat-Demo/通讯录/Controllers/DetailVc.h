//
//  DetailVc.h
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
NS_ASSUME_NONNULL_BEGIN

@interface DetailVc : UIViewController
@property (nonatomic,strong) JMSGUser *user;
//名字
@property (nonatomic,strong) UILabel *Name;
//详情tableview
@property (nonatomic,strong) UITableView *tab;

@end

NS_ASSUME_NONNULL_END
