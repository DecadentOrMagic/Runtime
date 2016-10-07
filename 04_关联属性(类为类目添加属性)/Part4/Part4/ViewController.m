//
//  ViewController.m
//  Part4
//
//  Created by 薛尧 on 16/10/6.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import "ViewController.h"
#import "UIControl+XYBlock.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    //  在开发中经常需要给已有的类添加方法和属性，但是Objective-C是不允许给已有类通过分类添加属性的，因为类分类是不会自动生成成员变量的。但是，我们可以通过运行时机制就可以做到了。
     
    /**
     *  Runtime提供的关联API，只有这三个API，使用也是非常简单的
     *
     *  void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     *
     *  id objc_getAssociatedObject(id object, const void *key)
     *
     *  void objc_removeAssociatedObjects(id object)
     *  实际上，我们几乎不会使用到objc_removeAssociatedObjects函数，这个函数的功能是移除指定的对象上所有的关联。既然我们要添加关联属性，几乎不会存在需要手动取消关联的场合。
     */
}


























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
