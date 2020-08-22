//
//  PhotoView.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/21.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoView : UIScrollView

@property(nonatomic,strong)NSMutableArray* model;


-(instancetype)initWithModel:(NSMutableArray*)array;
@end

NS_ASSUME_NONNULL_END
