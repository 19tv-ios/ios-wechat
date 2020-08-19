//
//  EmojiView.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/19.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojiView : UICollectionView

@property(nonatomic)bool isEmoji;

@property(nonatomic,strong)NSMutableArray* emojiArray;

@property(nonatomic,strong)UIImageView* imageview;
@end

NS_ASSUME_NONNULL_END
