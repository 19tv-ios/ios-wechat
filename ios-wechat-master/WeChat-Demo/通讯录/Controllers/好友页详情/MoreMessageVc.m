//
//  MoreMessageVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/9.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "MoreMessageVc.h"
#import "SDAutoLayout.h"
@interface MoreMessageVc ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MoreMessageVc

- (void)viewDidLoad {
    [super viewDidLoad];
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    tab.delegate = self;
    tab.dataSource = self;
    tab.sectionFooterHeight = 5;
    tab.sectionHeaderHeight = 5;
    [self.view addSubview:tab];
    tab.sd_layout.topEqualToView(self.view).leftEqualToView(self.view).rightEqualToView(self.view).bottomEqualToView(self.view);
    
    self.navigationItem.title = @"社交资料";
}

#pragma mark datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (section == 0) {
        return 1;
//    }else{
//        return 2;
//    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"我和他的共同群聊";
    }else{
        cell.textLabel.text = @"个性签名";
        UILabel *signLabel = [[UILabel alloc]init];
        signLabel.text = self.user.signature;//
        signLabel.textColor = [UIColor grayColor];
        [cell.contentView addSubview:signLabel];
        signLabel.sd_layout.rightEqualToView(cell.contentView).topEqualToView(cell.contentView).bottomEqualToView(cell.contentView);
        [signLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    return cell;
}

@end
