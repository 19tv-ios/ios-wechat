//
//  GetProtocol.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/6.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol GetProtocol <NSObject>

-(void)sendConversation:(NSMutableArray*)array;

-(void)sendMsg:(NSMutableArray*)ary;
@end
