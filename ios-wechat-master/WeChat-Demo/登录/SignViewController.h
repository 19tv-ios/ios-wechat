//
//  SignViewController.h
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Root.h"
@interface SignViewController : UIViewController
@property(nonatomic,weak)id<Root>delegate;
-(instancetype)initWithInfo:(NSDictionary *)dict;
@end
