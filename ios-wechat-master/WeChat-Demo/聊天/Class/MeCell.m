
//
//  MeCell.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/5.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "MeCell.h"
#import <SDAutoLayout.h>
#import "DetailVc.h"
#import <SDWebImage.h>
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
        UIImage* icon = [UIImage imageWithData:_icon];
        _iconImage.image = icon;
    
        [self.contentView sd_addSubviews:@[_picView,_iconImage] ];
        //NSLog(@"piccont");
    }else if(_voiceContent){
        _bubbleView = [[UIImageView alloc]init];
        _bubbleView = UIImageView.new;
        //_bubbleView.image = [UIImage imageNamed:@"send"];
        _bubbleView.backgroundColor = [UIColor colorWithRed:152/255.0 green:234/255.0 blue:112/255.0 alpha:1.0];
        _bubbleView.layer.borderWidth = 1;
        _bubbleView.layer.borderColor = [UIColor whiteColor].CGColor;
        _bubbleView.layer.cornerRadius = 10;
        
        _iconImage = [[UIImageView alloc] init];
        _iconImage = UIImageView.new;
        UIImage* icon = [UIImage imageWithData:_icon];
        if(icon){
            _iconImage.image = icon;
        }else{
            _iconImage.image = [UIImage imageNamed:@"微信"];
        }
        
        _voiceBtn = [[UIButton alloc]init];
        _voiceBtn = UIButton.new;
        [_voiceBtn addTarget:self action:@selector(tapVoiceBtn) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBtn setImage:_image forState:UIControlStateNormal];
        
        [self.contentView sd_addSubviews:@[_bubbleView,_iconImage,_voiceBtn] ];
    }else{
        _bubbleView = [[UIImageView alloc]init];
        _bubbleView = UIImageView.new;
        //_bubbleView.image = [UIImage imageNamed:@"send"];
        _bubbleView.backgroundColor = [UIColor colorWithRed:152/255.0 green:234/255.0 blue:112/255.0 alpha:1.0];
        _bubbleView.layer.borderWidth = 1;
        _bubbleView.layer.borderColor = [UIColor whiteColor].CGColor;
        _bubbleView.layer.cornerRadius = 5;
        
        _wordLabel = [[UILabel alloc] init];
        _wordLabel = UILabel.new;
        _wordLabel.text = _text;
        _wordLabel.textAlignment = NSTextAlignmentCenter;
        
        _iconImage = [[UIImageView alloc] init];
        _iconImage = UIImageView.new;
        UIImage* icon = [UIImage imageWithData:_icon];
        if(icon){
            _iconImage.image = icon;
        }else{
            _iconImage.image = [UIImage imageNamed:@"微信"];
        }
        
        [self.contentView sd_addSubviews:@[_bubbleView,_wordLabel,_iconImage] ];
    }
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToDetail)];
    _iconImage.userInteractionEnabled = YES;
    [_iconImage addGestureRecognizer:tap];
    
    UITapGestureRecognizer* tapPic = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photoView)];
    _picView.userInteractionEnabled = YES;
    [_picView addGestureRecognizer:tapPic];
//
    [self layout];
    //self.selectedBackgroundView = [[UIView alloc]init];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)layout{
    if(_picContent){
        _iconImage.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).widthIs(45).heightIs(45);
        _iconImage.sd_cornerRadius = [NSNumber numberWithInt:5];
        
        _picView.sd_layout.rightSpaceToView(_iconImage, 5).topSpaceToView(self.contentView, 5).widthIs(ScreenWeight/2 - 15).heightIs(200);
        _picView.sd_cornerRadius = [NSNumber numberWithInt:5];
        
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_enter(group);
//        [_picContent largeImageDataWithProgress:nil completionHandler:^(NSData *data, NSString *objectId, NSError *error) {
//            self->_imageData = data;
//            dispatch_group_leave(group);
//        }];
        [_picContent thumbImageData:^(NSData *data, NSString *objectId, NSError *error) {
            self->_imageData = data;
            dispatch_group_leave(group);
        }];
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            self->_picView.image = [UIImage imageWithData:self->_imageData];
//            self->_picView.image = [UIImage sd_imageWithGIFData:self->_imageData];
        });
    }else if(_voiceContent){
        _iconImage.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).widthIs(45).heightIs(45);
        _iconImage.sd_cornerRadius = [NSNumber numberWithInt:5];
        
        _bubbleView.sd_layout.rightSpaceToView(_iconImage, 5).topSpaceToView(self.contentView, 5).widthIs(ScreenWeight/2 - 75).heightIs(40);
        
        _voiceBtn.sd_layout.rightSpaceToView(_iconImage, 12).topSpaceToView(self.contentView, 12).heightIs(30).widthIs(100);
    }else{
        _iconImage.sd_layout.rightSpaceToView(self.contentView, 10).topSpaceToView(self.contentView, 0).widthIs(45).heightIs(45);
        _iconImage.sd_cornerRadius = [NSNumber numberWithInt:5];
        [_iconImage updateLayout];
        
        _wordLabel.preferredMaxLayoutWidth = _text.length * 10;
        
//        CGSize textBound = CGSizeMake(_text.length * 10, MAXFLOAT);
//        NSDictionary* textBoundParam = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
//        _labelHeight = [_wordLabel.text boundingRectWithSize:textBound options:NSStringDrawingUsesLineFragmentOrigin attributes:textBoundParam context:nil].size.height;
        
        if(_text.length < 5){
            _wordLabel.preferredMaxLayoutWidth = _text.length * 10;

            CGSize textBound = CGSizeMake(_text.length * 10, MAXFLOAT);
            NSDictionary* textBoundParam = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
            _labelHeight = [_wordLabel.text boundingRectWithSize:textBound options:NSStringDrawingUsesLineFragmentOrigin attributes:textBoundParam context:nil].size.height;
        }else if(_text.length < 15 && _text.length >= 5){
            _wordLabel.preferredMaxLayoutWidth = _text.length * 10;

            CGSize textBound = CGSizeMake(_text.length * 10, MAXFLOAT);
            NSDictionary* textBoundParam = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
            _labelHeight = [_wordLabel.text boundingRectWithSize:textBound options:NSStringDrawingUsesLineFragmentOrigin attributes:textBoundParam context:nil].size.height;
        }else{
            _wordLabel.preferredMaxLayoutWidth = ScreenWeight/2 - 50;

            CGSize textBound = CGSizeMake(ScreenWeight/2-50, MAXFLOAT);
            NSDictionary* textBoundParam = @{NSFontAttributeName : [UIFont systemFontOfSize:14]};
            _labelHeight = [_wordLabel.text boundingRectWithSize:textBound options:NSStringDrawingUsesLineFragmentOrigin attributes:textBoundParam context:nil].size.height;
        }
        _wordLabel.sd_layout.rightSpaceToView(_iconImage, 10).topSpaceToView(self.contentView, 15).widthIs(_wordLabel.preferredMaxLayoutWidth).autoHeightRatio(0);
        _wordLabel.font = [UIFont systemFontOfSize:14];
        
        _bubbleView.sd_layout.rightSpaceToView(_iconImage, 5).topSpaceToView(self.contentView, 5).widthIs(_wordLabel.preferredMaxLayoutWidth + 10).heightIs(_labelHeight + 15);
    }
}
-(void)tapVoiceBtn{
    [_voiceContent voiceData:^(NSData *data, NSString *objectId, NSError *error) {
        self->_voiceData = [[NSData alloc]init];
        self->_voiceData = data;
    }];
    _session =[AVAudioSession sharedInstance];
    NSError* err1;
    [_session setCategory:AVAudioSessionCategoryPlayback error:&err1];
    NSError* err2;
    _player = [[AVAudioPlayer alloc]initWithData:_voiceData error:&err2];
    if(err1){
        NSLog(@"%@",err1);
    }
    if(err2){
        NSLog(@"%@",err2);
    }
    [_player play];
    NSLog(@"播放语音");
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
-(instancetype)initWithImage:(JMSGImageContent *)content andIcon:(NSData*)data{
    self = [super init];
    _picContent = content;
    _icon = data;
    [self initSubviews];
    return self;
}
-(instancetype)initWithVoice:(JMSGVoiceContent *)content andPic:(UIImage *)image andIcon:(NSData *)data{
    self = [super init];
    _voiceContent = content;
    _image = image;
    _icon = data;
    [self initSubviews];
    return self;
}
-(void)pushToDetail{
    [self.delegate pushWithUser:_model.fromUser];
    //NSLog(@"delegate ==== ");
}
-(void)photoView{
    [self.delegate2 pushToPhotoView];
    //NSLog(@"p1");
}
@end
