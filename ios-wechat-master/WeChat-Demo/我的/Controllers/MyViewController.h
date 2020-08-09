//
//  MyViewController.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Root.h"
@interface MyViewController : UIViewController
@property(nonatomic,weak)id<Root>delegate;
@end
