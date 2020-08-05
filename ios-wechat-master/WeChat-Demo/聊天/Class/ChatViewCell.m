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
    _timeLabel.text = @"19:00";
    _timeLabel.font = [UIFont systemFontOfSize:10];
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel = UILabel.new;
    _nameLabel.text = @"TinoWu";
    _nameLabel.font = [UIFont systemFontOfSize:15 weight:1];
    
    _wordLabel = [[UILabel alloc]init];
    _wordLabel = UILabel.new;
    _wordLabel.text = @"哈哈哈哈哈";
    _wordLabel.font = [UIFont systemFontOfSize:12];
    
    [self.contentView sd_addSubviews:@[_timeLabel,_nameLabel,_wordLabel] ];
    
    [self layout];
    
}
-(void)layout{
    _timeLabel.sd_layout
              .rightSpaceToView(self.contentView, 0)
              .topSpaceToView(self.contentView,20)
              .autoHeightRatio(0)
              .widthIs(50)
    .heightIs(30);
    
    _nameLabel.sd_layout
              .leftSpaceToView(self.imageView, 10)
              .topEqualToView(self.imageView)
              .autoHeightRatio(0)
              .widthIs(70)
    .heightIs(30);
    
    _wordLabel.sd_layout
              .topSpaceToView(_nameLabel, 5)
              .leftSpaceToView(self.imageView, 10)
              .autoHeightRatio(0)
              .widthIs(150)
    .heightIs(30);
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    self.textLabel.text = @"TinoWu";
//    self.detailTextLabel.text = @"哈哈哈哈哈";
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [self initSubviews];
    return self;
}

@end
