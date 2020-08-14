//
//  GroupChat.h
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/13.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreatGroup.h"
@interface GroupChat : UIViewController

@property(nonatomic,strong)NSMutableArray* selectArray;

@property(nonatomic,strong)UIAlertAction* addAction;

@property(nonatomic,strong)UIAlertAction* cancelAction;

@property(nonatomic,weak)id<CreatGroup>delegate;
@end
