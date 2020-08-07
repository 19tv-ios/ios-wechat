//
//  GetMsg.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/6.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GetProtocol.h"
@interface GetMsg : NSObject

@property(nonatomic,strong)NSMutableArray* allMsg;

@property(nonatomic,weak)id<GetProtocol>delegate;

-(void)getMsgWithConversationArray:(NSMutableArray*)conversation;

@end
