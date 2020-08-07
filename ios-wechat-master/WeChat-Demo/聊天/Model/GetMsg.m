//
//  GetMsg.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/6.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "GetMsg.h"
#import <JMessage/JMessage.h>
@implementation GetMsg

-(void)getMsgWithConversationArray:(NSMutableArray *)conversation{
    for(JMSGConversation* ret in conversation){
        [ret allMessages:^(id resultObject, NSError *error) {
            [self.delegate sendMsg:resultObject];
        }];
    }
}

@end
