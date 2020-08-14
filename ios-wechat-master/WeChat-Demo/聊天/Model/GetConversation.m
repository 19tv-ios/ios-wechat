//
//  GetConversation.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/6.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "GetConversation.h"
#import <JMessage/JMessage.h>
@implementation GetConversation

-(void)getConversation{
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    _allConversation = [[NSMutableArray alloc]init];
    //JMSGConversation* conversation = [[JMSGConversation alloc]init];
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        for(JMSGConversation* ret in resultObject){
            [self->_allConversation addObject:ret];
        }
        [self.delegate sendConversation:self->_allConversation];
        dispatch_group_leave(group);
    }];
}

@end
