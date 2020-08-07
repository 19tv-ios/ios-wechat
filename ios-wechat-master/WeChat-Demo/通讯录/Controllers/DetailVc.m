//
//  DetailVc.m
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "DetailVc.h"

@interface DetailVc ()

@end

@implementation DetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightBtn = [[UIButton alloc]init];
    [rightBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnWay) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
}


#pragma mark 监听
- (void)rightBtnWay{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
