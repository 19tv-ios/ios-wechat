//
//  VoiceView.h
//  WeChat-Demo
//
//  Created by MacBook pro on 2020/8/17.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceView : UIView

@property (nonatomic,strong)UILabel *timeLabel;

@property (nonatomic,strong)UIView *colorView;

- (void)fillViewColorAndTime:(int)voiceNum :(NSString *)time;

@end


