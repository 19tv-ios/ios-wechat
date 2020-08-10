
//
//  MeCell.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "MeCell.h"
#import <SDAutoLayout.h>
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWeight [UIScreen mainScreen].bounds.size.width
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
    if(_picContent){
        _picView = [[UIImageView alloc]init];
        _picView = UIImageView.new;
        
        _iconImage = [[UIImageView alloc] init];
        _iconImage = UIImageView.new;
        UIImage* icon = [UIImage imageNamed:@"微信"];
        _iconImage.image = icon;
        
        [self.contentView sd_addSubviews:@[_picView,_iconImage] ];
        //NSLog(@"piccont");
    }else{
        _bubbleView = [[UIImageView alloc]init];
        _bubbleView = UIImageView.new;
        //_bubbleView.image = [UIImage imageNamed:@"send"];
        _bubbleView.backgroundColor = [UIColor colorWithRed:152/255.0 green:234/255.0 blue:112/255.0 alpha:1.0];
        _bubbleView.layer.borderWidth = 1;
        _bubbleView.layer.borderColor = [UIColor whiteColor].CGColor;
        _bubbleView.layer.cornerRadius = 10;
        
        _wordLabel = [[UILabel alloc] init];
        _wordLabel = UILabel.new;
        _wordLabel.text = _text;
        _wordLabel.textAlignment = NSTextAlignmentCenter;
        
        _iconImage = [[UIImageView alloc] init];
        _iconImage = UIImageView.new;
        UIImage* icon = [UIImage imageNamed:@"微信"];
        _iconImage.image = icon;
        
        [self.contentView sd_addSubviews:@[_bubbleView,_wordLabel,_iconImage] ];
    }
    [self layout];
    self.selectedBackgroundView = [[UIView alloc]init];
    
}
-(void)layout{
    if(_picContent){
        _iconImage.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).widthIs(50).heightIs(50);
        _iconImage.sd_cornerRadius = [NSNumber numberWithInt:20];
        
        _picView.sd_layout.rightSpaceToView(_iconImage, 5).topSpaceToView(self.contentView, 5).widthIs(ScreenWeight/2 - 15).heightIs(200);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
        [_picContent thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
            self->_imageData = data;
            dispatch_group_leave(group);
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            self->_picView.image = [UIImage imageWithData:self->_imageData];
            NSLog(@"加载图片完毕");
        });
    }else{
        _iconImage.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).widthIs(50).heightIs(50);
        _iconImage.sd_cornerRadius = [NSNumber numberWithInt:20];
        [_iconImage updateLayout];
        
        _wordLabel.preferredMaxLayoutWidth = ScreenWeight/2 - 30;
        _wordLabel.sd_layout.rightSpaceToView(_iconImage, 10).topSpaceToView(self.contentView, 15).widthIs(_wordLabel.preferredMaxLayoutWidth).autoHeightRatio(0);
        _wordLabel.font = [UIFont systemFontOfSize:14];
        CGSize textBound = CGSizeMake(ScreenWeight/2-30, MAXFLOAT);
        NSDictionary* textBoundParam = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
        _labelHeight = [_wordLabel.text boundingRectWithSize:textBound options:NSStringDrawingUsesLineFragmentOrigin attributes:textBoundParam context:nil].size.height;
        
        _bubbleView.sd_layout.rightSpaceToView(_iconImage, 0).topSpaceToView(self.contentView, 5).widthIs(ScreenWeight/2 - 15).heightIs(_labelHeight + 15);
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andText:(NSString*)text{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _text = text;
    [self initSubviews];
    return self;
}
-(instancetype)initWithText:(NSString *)text{
    self = [super init];
    _text = text;
    [self initSubviews];
    return self;
}
-(instancetype)initWithImage:(JMSGImageContent *)content{
    self = [super init];
    _picContent = content;
    [self initSubviews];
    return self;
}

@end
