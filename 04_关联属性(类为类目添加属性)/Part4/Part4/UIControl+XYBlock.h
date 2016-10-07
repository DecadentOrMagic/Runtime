//
//  UIControl+XYBlock.h
//  Part4
//
//  Created by 薛尧 on 16/10/6.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^XYTouchUpBlock)(id sender);

@interface UIControl (XYBlock)

@property (nonatomic, copy) XYTouchUpBlock xy_touchUpBlock;

@end
