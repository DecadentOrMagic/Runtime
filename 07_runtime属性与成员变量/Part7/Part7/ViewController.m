//
//  ViewController.m
//  Part7
//
//  Created by 薛尧 on 16/10/7.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import "ViewController.h"

#import "PropertyLearn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // 在runtime中，objc_property_t代表属性，Ivar代表成员变量。本篇讲解这两大类型的具体实现、区别及各自常用的操作。
    
    /**
     *  typedef struct objc_property *objc_property_t;
     *
     *  objc_property_t代表属性，而它又是一个结构体指针
     *  objc_property是内置的类型，与之关联的还有一个objc_property_attribute_t，它是属性的attribute，也就是其实是对属性的详细描述，包括属性名称、属性编码类型、原子类型/非原子类型等。(定义请看API,其中，value通常是空的，但是对于类型是有值的。)
     */
    
    [PropertyLearn test];
}











- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
