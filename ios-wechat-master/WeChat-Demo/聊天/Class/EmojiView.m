//
//  EmojiView.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/19.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "EmojiView.h"

@implementation EmojiView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewFlowLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    // 创建布局
    layout.itemSize = CGSizeMake(80, 80);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _isEmoji = NO;
    [self setupEmojiArray];
    self.backgroundColor = [UIColor whiteColor];
    //_imageview = [[UIImageView alloc]initWithFrame:];
    //_imageview.backgroundColor = [UIColor redColor];
    [self addSubview:_imageview];
    
    return self;
}
-(void)setupEmojiArray{
    UIImage* emoji1 = [UIImage imageNamed:@"pic1"];
    UIImage* emoji2 = [UIImage imageNamed:@"pic2"];
    UIImage* emoji3 = [UIImage imageNamed:@"pic3"];
    UIImage* emoji4 = [UIImage imageNamed:@"pic4"];
    UIImage* emoji5 = [UIImage imageNamed:@"pic5"];
    UIImage* emoji6 = [UIImage imageNamed:@"pic6"];
    UIImage* emoji7 = [UIImage imageNamed:@"pic7"];
    
    _emojiArray = [[NSMutableArray alloc]init];
    [_emojiArray addObjectsFromArray:@[emoji1,emoji2,emoji3,emoji4,emoji5,emoji6,emoji7] ];
}
@end
