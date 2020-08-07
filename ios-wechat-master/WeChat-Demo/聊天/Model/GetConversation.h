//
//  GetConversation.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/6.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMessage/JMessage.h>
#import "GetProtocol.h"
@interface GetConversation : NSObject

@property(nonatomic,strong)NSMutableArray* allConversation;

@property(nonatomic,weak)id<GetProtocol>delegate;
-(void)getConversation;
@end
