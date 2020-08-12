//
//  MeCell.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JMessage/JMessage.h>
#import "PushToDetail.h"
@interface MeCell : UITableViewCell

@property(nonatomic,strong)UIImageView* bubbleView;

@property(nonatomic,strong)UILabel* wordLabel;

@property(nonatomic,strong)UIImageView* iconImage;

@property(nonatomic,strong)NSString* text;

@property(nonatomic)CGFloat labelHeight;

@property(nonatomic,strong)NSData* imageData;

@property(nonatomic,strong)JMSGImageContent* picContent;

@property(nonatomic,strong)JMSGMessage* model;

@property(nonatomic,strong)UIImageView* picView;

@property(nonatomic,weak)id<PushToDetail>delegate;

@property(nonatomic,strong)NSData* icon;
-(instancetype)initWithText:(NSString*)text andIcon:(NSData*)data;
-(instancetype)initWithImage:(JMSGImageContent*)content;
@end
