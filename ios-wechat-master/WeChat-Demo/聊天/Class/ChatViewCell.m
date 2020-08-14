//
//  ChatViewCell.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "ChatViewCell.h"
#import <SDAutoLayout.h>
@implementation ChatViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initSubviews{
    _timeLabel = [[UILabel alloc]init];
    _timeLabel = UILabel.new;
    NSTimeInterval interval = [_model.latestMsgTime doubleValue]/1000;
    NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm"];
    NSString* lastTime = [formatter stringFromDate:lastDate];
    _timeLabel.text = [NSString stringWithFormat:@"%@",lastTime];
    _timeLabel.font = [UIFont systemFontOfSize:10];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel = UILabel.new;
    _nameLabel.text = _model.title;
    _nameLabel.font = [UIFont systemFontOfSize:15 weight:1];
    
    _wordLabel = [[UILabel alloc]init];
    _wordLabel = UILabel.new;
    _wordLabel.text = _model.latestMessageContentText;
    _wordLabel.font = [UIFont systemFontOfSize:12];
    
    _iconView = [[UIImageView alloc]init];
    _iconView = UIImageView.new;
    
    [self.contentView sd_addSubviews:@[_timeLabel,_nameLabel,_wordLabel,_iconView] ];
    
    [self layout];
    
}
-(void)layout{
    _timeLabel.sd_layout
              .rightSpaceToView(self.contentView, 0)
              .topSpaceToView(self.contentView,20)
              .autoHeightRatio(0)
              .widthIs(50)
    .heightIs(30);
    
    
    
    _iconView.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 15).heightIs(50).widthIs(50);
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 5;
    [_iconView updateLayout];
    
    _nameLabel.sd_layout
    .leftSpaceToView(_iconView, 10)
    .topEqualToView(_iconView)
    .autoHeightRatio(0)
    .widthIs(70)
    .heightIs(30);
    [_nameLabel updateLayout];
    
    _wordLabel.sd_layout
    .topSpaceToView(_nameLabel, 5)
    .leftSpaceToView(_iconView, 10)
    .autoHeightRatio(0)
    .widthIs(150)
    .heightIs(30);
    [_wordLabel setMaxNumberOfLinesToShow:2];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andModel:(JMSGConversation *)model{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    self.textLabel.text = @"TinoWu";
//    self.detailTextLabel.text = @"哈哈哈哈哈";
    _model = model;
    //NSLog(@"%@",_model.title);
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self initSubviews];
    return self;
}

@end
