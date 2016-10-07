//
//  UIControl+XYBlock.m
//  Part4
//
//  Created by 薛尧 on 16/10/6.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import "UIControl+XYBlock.h"

#import <objc/runtime.h>

static const void *sXYUIControlTouchUpEventBlockKey = "sXYUIControlTouchUpEventBlockKey";

@implementation UIControl (XYBlock)

- (void)setXy_touchUpBlock:(XYTouchUpBlock)xy_touchUpBlock
{
    /**
     *  void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     *  
     *  1.object：与谁关联，通常是传self
     *  2.key：唯一键，在获取值时通过该键获取，通常是使用static const void *来声明
     *  3.value：关联所设置的值
     *  4.policy：内存管理策略，比如使用copy
     */
    objc_setAssociatedObject(self, sXYUIControlTouchUpEventBlockKey, xy_touchUpBlock, OBJC_ASSOCIATION_COPY);
    
    [self removeTarget:self action:@selector(xyOnTouchUp:) forControlEvents:UIControlEventTouchDragInside];
    
    if (xy_touchUpBlock) {
        [self addTarget:self action:@selector(xyOnTouchUp:) forControlEvents:UIControlEventTouchDragInside];
    }
}

- (XYTouchUpBlock)xy_touchUpBlock
{
    /**
     *  id objc_getAssociatedObject(id object, const void *key)
     *
     *  1.object：与谁关联，通常是传self，在设置关联时所指定的与哪个对象关联的那个对象
     *  2.key：唯一键，在设置关联时所指定的键
     */
    return objc_getAssociatedObject(self, sXYUIControlTouchUpEventBlockKey);
}

/**
 *  关联策略
 *
 *  objc_AssociationPolicy // 点击去查看api
 *
 *  1.OBJC_ASSOCIATION_ASSIGN：表示弱引用关联，通常是基本数据类型，如int、float，非线程安全
 *  2.OBJC_ASSOCIATION_RETAIN_NONATOMIC：表示强（strong）引用关联对象，非线程安全
 *  3.OBJC_ASSOCIATION_COPY_NONATOMIC：表示关联对象copy，非线程安全
 *  4.OBJC_ASSOCIATION_RETAIN：表示强（strong）引用关联对象，是线程安全的
 *  5.OBJC_ASSOCIATION_COPY：表示关联对象copy，是线程安全的
 */

- (void)xyOnTouchUp:(UIButton *)sender
{
    XYTouchUpBlock touchUp = self.xy_touchUpBlock;
    
    if (touchUp) {
        touchUp(sender);
    }
}

@end
