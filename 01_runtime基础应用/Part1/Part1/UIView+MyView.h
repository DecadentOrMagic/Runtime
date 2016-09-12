//
//  UIView+MyView.h
//  Part1
//
//  Created by 薛尧 on 16/9/12.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MyView)

// iOS的category是不能追加存储属性的，但是我们可以通过运行时关联来追加“属性”。
// OC的分类允许给分类添加属性，但不会自动生成getter、setter方法。
@property (nonatomic, assign) BOOL   is;
@property (nonatomic, copy) NSString *name;

@end
