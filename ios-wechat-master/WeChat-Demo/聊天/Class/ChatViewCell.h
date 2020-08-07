//
//  ChatViewCell.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
@interface ChatViewCell : UITableViewCell

@property(nonatomic,strong)UILabel* timeLabel;

@property(nonatomic,strong)UILabel* nameLabel;

@property(nonatomic,strong)UILabel* wordLabel;

@property(nonatomic,strong)JMSGConversation* model;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(JMSGConversation*)model;
-(void)initSubviews;
@end
