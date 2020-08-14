//
//  CreatGroup.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/13.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>
@protocol CreatGroup <NSObject>

-(void)creatConversationWithGroup:(JMSGGroup*)group;

@end
