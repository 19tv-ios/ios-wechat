//
//  accountModel.m
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/11.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "accountModel.h"

@implementation accountModel

+(instancetype)accountdataWithdict:(NSDictionary *)dict {
    accountModel *model = [[self alloc] init];
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
