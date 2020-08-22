//
//  PhotoView.m
//  WeChat-Demo
//
//  Created by mac os on 2020/8/21.
//  Copyright © 2020 mac os. All rights reserved.
//

#import "PhotoView.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWeight [UIScreen mainScreen].bounds.size.width
@implementation PhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithModel:(NSMutableArray*)array{
    self = [super init];
    _model = [[NSMutableArray alloc]init];
    _model = array;
    
    self.frame = CGRectMake(0, 0, ScreenWeight, ScreenHeight);
    self.contentOffset = CGPointMake(self.frame.size.width, 0);
    self.contentSize = CGSizeMake(ScreenWeight * _model.count, ScreenHeight);
    self.backgroundColor = [UIColor blackColor];
    
    if(_model.count>0){
        NSInteger cnt = 0;
        for(UIImage* image in _model){
            UIScrollView* single = [[UIScrollView alloc]initWithFrame:CGRectMake(ScreenWeight * cnt,0,ScreenWeight, ScreenHeight)];
            UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, ScreenHeight / 2 - 120, ScreenWeight, 300)];
            imageView.image = image;
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
            [single addGestureRecognizer:tap];
            [single addSubview:imageView];
            
            [self addSubview:single];
            
            cnt++;
        }
    }
    NSLog(@"%@",_model);
    return self;
}
-(void)dismiss{
    self.hidden = YES;
    NSLog(@"hide");
}
@end
