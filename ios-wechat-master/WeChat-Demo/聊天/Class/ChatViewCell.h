//
//  ChatViewCell.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatViewCell : UITableViewCell

@property(nonatomic,strong)UILabel* timeLabel;

@property(nonatomic,strong)UILabel* nameLabel;

@property(nonatomic,strong)UILabel* wordLabel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)initSubviews;
@end
