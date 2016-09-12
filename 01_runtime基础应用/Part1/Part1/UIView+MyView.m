//
//  UIView+MyView.m
//  Part1
//
//  Created by 薛尧 on 16/9/12.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import "UIView+MyView.h"

#import <objc/runtime.h>

@implementation UIView (MyView)

/**
 *  setter方法，使用到了 objc_setAssociatedObject(<#id object#>, <#const void *key#>, <#id value#>, <#objc_AssociationPolicy policy#>)
 *  第一个参数 <#id object#> 是要添加属性的对象,这里就是自己self
 *  第二个参数 <#const void *key#> 是关键字选择器,就是通过这个关键字的方法找到对象的那个属性,一般用@selector(属性名)
 *  第三个参数 <#id value#> 就是给属性设置你想设置的值
 *  第四个参数 <#objc_AssociationPolicy policy#> 是一个枚举类型,默认使用第一个
 */
/**
 *  第四个参数 关联策略 是一个枚举值
 *  OBJC_ASSOCIATION_ASSIGN =           0,    //关联对象的属性是弱引用
 *  OBJC_ASSOCIATION_RETAIN_NONATOMIC = 1,    //关联对象的属性是强引用并且关联对象不使用原子性
 *  OBJC_ASSOCIATION_COPY_NONATOMIC =   3,    //关联对象的属性是copy并且关联对象不使用原子性
 *  OBJC_ASSOCIATION_RETAIN =           01401,//关联对象的属性是copy并且关联对象使用原子性
 *  OBJC_ASSOCIATION_COPY =             01403 //关联对象的属性是copy并且关联对象使用原子性
 */
- (void)setName:(NSString *)name
{
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_ASSIGN);
}

/**
 *  getter方法，使用了 objc_getAssociatedObject(<#id object#>, <#const void *key#>)
 *  第一个参数 <#id object#> 是要添加属性的对象,这里就是self
 *  第二个参数 <#const void *key#> 关键字选择器,就是通过这个关键字的方法找到对象的那个属性,一般用@selector(属性名)
 *  注意，第二个关键字可传 _cmd,代表方法名本身。每一个方法内都有一个_cmd，表示方法自身。
 */
- (NSString *)name
{
    return objc_getAssociatedObject(self, _cmd);
}


- (void)setIs:(BOOL)is
{
    objc_setAssociatedObject(self, @selector(is), @(is), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)is
{
    return [objc_getAssociatedObject(self, @selector(is)) boolValue];
}

@end
