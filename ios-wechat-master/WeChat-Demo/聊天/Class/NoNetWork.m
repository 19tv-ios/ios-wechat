//
//  NoNetWork.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/10.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "NoNetWork.h"

@implementation NoNetWork

-(void)setup{
    UILabel* noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 300, 30)];
    noteLabel.text = @"无法连接到服务器，请检查网络";
    noteLabel.textAlignment = NSTextAlignmentCenter;
    noteLabel.textColor = [UIColor whiteColor];
    [self addSubview:noteLabel];
    
    self.backgroundColor = [UIColor grayColor];
}

@end
