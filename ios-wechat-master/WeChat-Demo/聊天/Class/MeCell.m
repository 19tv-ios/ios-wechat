
//
//  MeCell.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "MeCell.h"
#import <SDAutoLayout.h>
@implementation MeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initSubviews{
    _bubbleView = [[UIImageView alloc]init];
    _bubbleView = UIImageView.new;
    _bubbleView.image = [UIImage imageNamed:@"send"];
    
    _wordLabel = [[UILabel alloc] init];
    _wordLabel = UILabel.new;
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage = UIImageView.new;
    
    [self.contentView sd_addSubviews:@[_bubbleView,_wordLabel,_iconImage] ];
    
    [self layout];
}
-(void)layout{
    _iconImage.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 10).widthIs(50).heightIs(50);
    _iconImage.sd_cornerRadius = [NSNumber numberWithInt:30];
    [_iconImage updateLayout];
    
    _bubbleView.sd_layout.rightSpaceToView(_iconImage, 0).topSpaceToView(self.contentView, 5).widthIs(150).heightIs(50);
    
    _wordLabel.sd_layout.rightSpaceToView(_iconImage, 10).topSpaceToView(self.contentView, 10).widthIs(120).heightIs(30);
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    [self initSubviews];
    return self;
}

@end
