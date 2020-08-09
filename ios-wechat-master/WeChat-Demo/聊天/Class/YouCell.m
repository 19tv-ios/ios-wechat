//
//  YouCell.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "YouCell.h"
#import <SDAutoLayout.h>
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWeight [UIScreen mainScreen].bounds.size.width
@implementation YouCell

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
    //_bubbleView.image = [UIImage imageNamed:@"send"];
    _bubbleView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    _bubbleView.layer.borderWidth = 1;
    _bubbleView.layer.borderColor = [UIColor whiteColor].CGColor;
    _bubbleView.layer.cornerRadius = 10;
    
    _wordLabel = [[UILabel alloc] init];
    _wordLabel = UILabel.new;
    _wordLabel.text = _text;
    _wordLabel.textAlignment = NSTextAlignmentCenter;
    //_wordLabel.backgroundColor = [UIColor redColor];
    
    _iconImage = [[UIImageView alloc] init];
    _iconImage = UIImageView.new;
    UIImage* icon = [UIImage imageWithData:_icon];
    if(icon){
        _iconImage.image = icon;
    }else{
        _iconImage.image = [UIImage imageNamed:@"微信"];
    }
    
    [self.contentView sd_addSubviews:@[_bubbleView,_wordLabel,_iconImage] ];
    
    [self layout];
    self.selectedBackgroundView = [[UIView alloc]init];
}
-(void)layout{
    _iconImage.sd_layout.leftSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).widthIs(50).heightIs(50);
    _iconImage.sd_cornerRadius = [NSNumber numberWithInt:20];
    [_iconImage updateLayout];
    
    _wordLabel.preferredMaxLayoutWidth = ScreenWeight/2 - 30;
    _wordLabel.sd_layout.leftSpaceToView(_iconImage, 7).topSpaceToView(self.contentView, 15).widthIs(_wordLabel.preferredMaxLayoutWidth - 10).autoHeightRatio(0);
    _wordLabel.font = [UIFont systemFontOfSize:14];
    
    CGSize textBound = CGSizeMake(ScreenWeight/2-30, MAXFLOAT);
    NSDictionary* textBoundParam = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
    _labelHeight = [_wordLabel.text boundingRectWithSize:textBound options:NSStringDrawingUsesLineFragmentOrigin attributes:textBoundParam context:nil].size.height;
    
    _bubbleView.sd_layout.leftSpaceToView(_iconImage, 0).topSpaceToView(self.contentView, 5).widthIs(ScreenWeight/2 - 15).heightIs(_labelHeight + 15);
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andText:(NSString*)text{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _text = text;
    [self initSubviews];
    return self;
}
-(instancetype)initWithText:(NSString *)text andIcon:(NSData *)data{
    self = [super init];
    _text = text;
    _icon = data;
    [self initSubviews];
    return self;
}

@end
