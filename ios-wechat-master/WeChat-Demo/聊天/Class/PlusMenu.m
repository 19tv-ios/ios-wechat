//
//  PlusMenu.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/10.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "PlusMenu.h"
#import <SDAutoLayout.h>
#import "AddFriendsVc.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWeight [UIScreen mainScreen].bounds.size.width
extern CGFloat height;

@implementation PlusMenu

-(void)viewDidLoad{
    [super viewDidLoad];
    _tableview = [[UITableView alloc]init];
    _tableview = UITableView.new;
    [self.view addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    self.view.frame = CGRectMake(0, 87, ScreenWeight, ScreenHeight-170);
    self.view.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    
    [self setupMenu];
    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
//    [self.view addGestureRecognizer:tap];
}
-(void)setupMenu{
    _tableview.sd_layout
    .rightSpaceToView(self.view, 5)
    .topSpaceToView(self.view, 5)
    .widthIs(160)
    .heightIs(100);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"plus"];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"plus"];
    }
    if(indexPath.row == 0){
        cell.textLabel.text = @"发起群聊";
        cell.imageView.image = [UIImage imageNamed:@"群聊入口"];
        //NSLog(@"======");
    }else{
        cell.textLabel.text = @"新增好友";
        cell.imageView.image = [UIImage imageNamed:@"添加好友"];
    }
    //NSLog(@"===== --- ");
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 1){
        [self.delegate pushToAddFriends];
        self.view.hidden = YES;
        _hasMenu = NO;
    }else{
        [self.delegate pushToGroupChat];
        self.view.hidden = YES;
        _hasMenu = NO;
    }
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}
//-(void)hide{
//    _menu.hidden = YES;
//    hasMenu = NO;
//}

@end
