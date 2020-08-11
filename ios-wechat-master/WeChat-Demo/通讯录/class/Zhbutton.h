//
//  Zhbutton.h
//  WeChat-Demo
//
//  Created by fu00 on 2020/8/6.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
NS_ASSUME_NONNULL_BEGIN

@interface Zhbutton : UIButton
@property (nonatomic,strong) JMSGUser *user;
@property (nonatomic,assign) NSInteger row;
@end

NS_ASSUME_NONNULL_END
