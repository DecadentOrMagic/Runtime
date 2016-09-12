//
//  ViewController.m
//  Part1
//
//  Created by 薛尧 on 16/9/8.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>
#import <objc/message.h>

#import "Person.h"

#import "UIView+MyView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /**
     *  运行时机制
     *
     *  Runtime是一套比较底层的纯C语言的API, 属于C语言库, 包含了很多底层的C语言API。 在我们平时编写的iOS代码中, 最终都是转成了runtime的C代码。
     *  所谓运行时，也就是在编译时是不确定的，只是在运行过程中才去确定对象的类型、方法等。利用Runtime机制可以在程序运行时动态修改类、对象中的所有属性、方法等。
     *  还记得我们在网络请求数据处理时，调用了-setValuesForKeysWithDictionary:方法来设置模型的值。这里什么原理呢？为什么能这么做？其实就是通过Runtime机制来完成的，内部会遍历模型类的所有属性名，然后设置与key对应的属性名的值。
     *  我们在使用运行时的地方，都需要包含头文件：#import <objc/runtime.h>。如果是Swift就不需要包含头文件，就可以直接使用了。
     */
    
    // 获取对象所有属性名
//    [self allProperties];
    
    // 获取对象的所有属性名和属性值
//    [self allPropertyNamesAndValues];
    
    // 获取对象的所有方法名
//    [self allMethods];
    
    // 获取对象的成员变量
//    [self allMemberVariables];
    
    // 运行时发消息
//    [self messageSend];
    
    // 动态为category添加属性
    [self addPropertyForCategory];
}

/**
 *  1.获取对象所有属性名
 *  2.获取对象的所有属性名和属性值
 *  3.获取对象的所有方法名
 *  4.获取对象的成员变量
 *  5.运行时发消息
 *  6.动态为category添加属性
 */


#pragma mark - 1.获取对象所有属性名
- (void)allProperties
{
    Person *p = [[Person alloc] init];
    p.name = @"Lili";
    
    // class_getInstanceSize 返回一个类的实例的大小
    size_t size = class_getInstanceSize(p.class);
    NSLog(@"size=%ld",size);
    
    for (NSString *propertyName in p.allProperties) {
        NSLog(@"%@",propertyName);
    }
}


#pragma mark - 2.获取对象的所有属性名和属性值
- (void)allPropertyNamesAndValues
{
    Person *p = [[Person alloc] init];
    p.name = @"Lili";
    NSDictionary *dict = p.allPropertyNamesAndValues;
    for (NSString *propertyName in dict.allKeys) {
        NSLog(@"propertyName: %@ , propertyValue: %@",propertyName,dict[propertyName]);
    }
    // 属性值为空的属性并没有打印出来，因此字典的key对应的value不能为nil
}


#pragma mark - 3.获取对象的所有方法名
- (void)allMethods
{
    Person *p = [[Person alloc] init];
    p.name = @"Lili";
    [p allMethods];
    // 调用打印结果，为什么参数个数看起来不匹配呢？比如-allProperties方法，其参数个数为0才对，但是打印结果为2。根据打印结果可知，无参数时，值就已经是2了。
}


#pragma mark - 4.获取对象的成员变量
- (void)allMemberVariables
{
    Person *p = [[Person alloc] init];
    p.name = @"Lili";
    for (NSString *varName in p.allMemberVariables) {
        NSLog(@"%@",varName);
    }
}


#pragma mark - 5.运行时发消息
- (void)messageSend
{
    Person *p = [[Person alloc] init];
    p.name = @"Lili";
    objc_msgSend(p,@selector(allMethods));
    // 这样就相当于手动调用[p allMethods];。但是编译器会报错，问题提示期望的参数为0，但是实际上有两个参数。解决办法是，关闭严格检查,详见 解决调用objc_msgSend出错问题.jpeg
}


#pragma mark - 6.动态为category添加属性
- (void)addPropertyForCategory
{
    UIView *view = [[UIView alloc] init];
    view.name = @"我的view";
}




















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
