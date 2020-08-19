//
//  VoiceView.m
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/17.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "VoiceView.h"
#import "SDAutoLayout.h"

@implementation VoiceView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius= 8.0;
        self.layer.borderWidth = 1.f;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = [UIColor blackColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.text = @"60s";
        [self addSubview:_timeLabel];
        _timeLabel.sd_layout
        .topSpaceToView(self, 5)
        .leftSpaceToView(self, 5)
        .rightSpaceToView(self, 5)
        .heightIs(35);
        
        _colorView = [[UIView alloc] init];
        _colorView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_colorView];
        _colorView.sd_layout
        .topSpaceToView(_timeLabel,0)
        .leftSpaceToView(self, 5)
        .rightSpaceToView(self, 5)
        .bottomSpaceToView(self, 10);
        
        for (int i=0; i<8; i++) {
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [UIColor lightGrayColor];
            //view.backgroundColor = [UIColor colorWithRed:95/255.0 green:212/255.0 blue:124/255.0 alpha:1.0];
            [_colorView addSubview:view];
            if (i==0) {
                view.sd_layout.bottomSpaceToView(self.colorView, 25).widthIs(6).heightIs(12)
                .leftSpaceToView(self.colorView, 35);
            }else {
                UIView *preView = self.colorView.subviews[i-1];
                view.sd_layout.bottomSpaceToView(self.colorView, 25).widthIs(6).heightIs(12+5*i).leftSpaceToView(preView, 3);
            }
        }
    }
    return self;
}

- (void)fillViewColorAndTime:(int)voiceNum :(NSString *)time {
    
    int index = 0;
    for (int i=0; i<self.colorView.subviews.count; i++) {
        UIView *view = self.colorView.subviews[i];
        if (view.backgroundColor == [UIColor colorWithRed:95/255.0 green:212/255.0 blue:124/255.0 alpha:1.0]) {
            index = i;
        }else {
        }
    }
    if (index<voiceNum) {
        for (int i=index; i<voiceNum; i++) {
             UIView *view = self.colorView.subviews[i];
            view.backgroundColor =  [UIColor colorWithRed:95/255.0 green:212/255.0 blue:124/255.0 alpha:1.0];
        }
    }
    if (index>voiceNum) {
        for (int i=voiceNum; i<index; i++) {
            UIView *view = self.colorView.subviews[i];
            view.backgroundColor =  [UIColor lightGrayColor];
        }
    }
    
    _timeLabel.text = time;
}
@end
