//
//  ChatController.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
@interface ChatController : UIViewController

@property(nonatomic,strong)UITableView* tableview;

@property(nonatomic,strong)UITextView* textView;

@property(nonatomic,strong)UIButton* sendBtn;

@property(nonatomic,strong)UIView* bottomView;

@property(nonatomic,strong)UIButton* emojiBtn;

@property(nonatomic,strong)UIButton* plusBtn;

@property(nonatomic,strong)NSMutableArray* msgArray;

@property(nonatomic,strong)JMSGMessage* model;

-(instancetype)initWithMsg:(JMSGMessage*)msg;
//-(void)getAllMsg;
@end
