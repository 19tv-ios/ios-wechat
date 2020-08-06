//
//  ChatViewController.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/4.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewCell.h"
#import "ChatController.h"
#import <JMessage/JMessage.h>
#import "GetConversation.h"
#import "GetMsg.h"
#import "GetProtocol.h"
@interface ChatViewController : UIViewController<GetProtocol>

@property(nonatomic,strong) UITableView* tableview;

@property(nonatomic,strong) UISearchController* search;

@property(nonatomic,strong) ChatController* chatController;

@property(nonatomic,strong) NSMutableArray* conversationArray;

@property(nonatomic,strong) NSMutableArray* msgArray;

@property(nonatomic,strong) JMSGConversation* model;

@property(nonatomic,strong) GetConversation* getModel;

@property(nonatomic,strong) GetMsg* getMsg;

@property(nonatomic,strong) NSString* address;

@property(nonatomic,strong) JMSGMessage* certainMsg;
-(void)getMsgModel;
@end
