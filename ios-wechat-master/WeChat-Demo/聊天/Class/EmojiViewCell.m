//
//  EmojiViewCell.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/19.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "EmojiViewCell.h"

@implementation EmojiViewCell

-(instancetype)init{
    self = [super init];
    _imageView = [[UIImageView alloc]initWithFrame:self.frame];
    [self addSubview:_imageView];
    return self;
}

@end
