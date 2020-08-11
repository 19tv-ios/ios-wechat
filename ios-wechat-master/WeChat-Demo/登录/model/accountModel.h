//
//  accountModel.h
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/11.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface accountModel : NSObject
//用户名
@property (nonatomic, copy) NSString *username;
//密码
@property (nonatomic, copy) NSString *password;
//自动登录
@property (nonatomic, assign) BOOL autoLogin;
//记住密码
@property (nonatomic, assign) BOOL remindpassword;
//快速赋值
+(instancetype)accountdataWithdict:(NSDictionary *)dict;
@end
