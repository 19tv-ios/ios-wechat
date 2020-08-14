//
//  BringMenu.h
//  WeChat-Demo
//
//  Created by mac os on 2020/8/13.
//  Copyright © 2020 mac os. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlusMenu.h"
@protocol BringMenu <NSObject>

-(void)bringMenu:(PlusMenu*)view;

@end
