//
//  ChatController.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
@interface ChatController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView* tableview;

@property(nonatomic,strong)UITextField* textView;

@property(nonatomic,strong)UIButton* sendBtn;

@property(nonatomic,strong)UIView* bottomView;

@property(nonatomic,strong)UIButton* emojiBtn;

@property(nonatomic,strong)UIButton* plusBtn;

@property(nonatomic,strong)NSMutableArray* msgArray;

@property(nonatomic,strong)JMSGMessage* model;

@property(nonatomic,strong)NSData* iconData;

@property(nonatomic,strong)NSString* otherSide;

@property(nonatomic,strong)JMSGMessage* freshMsg;

@property(nonatomic,strong)JMSGConversation* conModel;

@property(nonatomic)CGFloat cellHeight;

@property(nonatomic,strong)UIImagePickerController* picker;

@property(nonatomic,strong)NSData* picData;

@property(nonatomic,strong)JMSGMessage* lastmsg;
-(instancetype)initWithMsg:(NSMutableArray*)msg;
//-(void)getAllMsg;
@end
