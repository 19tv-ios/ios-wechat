//
//  PlusMenu.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/10.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlusMenu : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView* tableview;

@end
