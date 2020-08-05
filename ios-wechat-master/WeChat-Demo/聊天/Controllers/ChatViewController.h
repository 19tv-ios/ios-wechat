//
//  ChatViewController.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewCell.h"
#import "ChatController.h"
@interface ChatViewController : UIViewController

@property(nonatomic,strong) UITableView* tableview;

@property(nonatomic,strong) UISearchController* search;

@property(nonatomic,strong) ChatController* chatController;
@end
