//
//  PushToDetail.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/11.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>
@protocol PushToDetail <NSObject>

-(void)pushWithUser:(JMSGUser*)user;

@end
