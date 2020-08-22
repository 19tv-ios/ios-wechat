//
//  Conversation.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/21.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Realm/Realm.h>

NS_ASSUME_NONNULL_BEGIN

@interface Conversation : RLMObject

@property NSString* title;

@property NSString* lastMsg;

@property NSString* lastTime;

@property NSData* iconData;

@end

NS_ASSUME_NONNULL_END
