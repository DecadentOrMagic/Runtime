//
//  Person.m
//  Part1
//
//  Created by 薛尧 on 16/9/8.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import "Person.h"

#import <objc/runtime.h>

// 这里的objc_property_t是一个结构体指针objc_property *，因此我们声明的properties就是二维指针。
//typedef struct objc_property *objc_property_t;

@implementation Person


#pragma mark - 获取对象所有属性名
- (NSArray *)allProperties
{
    unsigned int count; // 16位 是无符号整型 
    
    // 获取类的所有属性
    // 如果没有属性,则count为0,properties为nil
    // properties就是二维数组指针
    // class_copyPropertyList 方法获取所有的属性名称。
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (NSUInteger i = 0; i < count; i++) {
        // 获取属性名称
        // property_getName 获取属性名 ; property_getAttributes 获取属性特性描述字符串 ; property_copyAttributeList 获取所有属性特性
        const char *propertyName = property_getName(properties[i]);
        NSString *name = [NSString stringWithUTF8String:propertyName];
        
        [propertiesArray addObject:name];
    }
    
    // 在使用完成后，我们一定要记得释放内存，否则会造成内存泄露。这里是使用的是C语言的API，因此我们也需要使用C语言的释放内存的方法free。
    // 注意,这里properties是一个数组指针,是C的语法
    // 我们需要使用free函数来释放内存,否则会造成内存泄漏
    free(properties);
    
    return propertiesArray;
}


#pragma mark - 获取对象的所有属性名和属性值
- (NSDictionary *)allPropertyNamesAndValues
{
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        
        // 得到属性名
        NSString *propertyName = [NSString stringWithUTF8String:name];
        
        // 获取属性值
        id propertyValue = [self valueForKey:propertyName];
        
        if (propertyName && propertyValue != nil) {
            [resultDict setObject:propertyValue forKey:propertyName];
        }
    }
    
    // 记得释放
    free(properties);
    
    return resultDict;
}


#pragma mark - 获取对象的所有方法名
- (void)allMethods
{
    // 通过class_copyMethodList方法就可以获取所有的方法。
    unsigned int outCount = 0;
    Method *methods = class_copyMethodList([self class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        
        // 获取方法名称,但是类型是一个SEL选择器类型
        SEL methodSEL = method_getName(method);
        // 需要获取c字符串
        const char *name = sel_getName(methodSEL);
        // 将方法名转换成OC字符串
        NSString *methodName = [NSString stringWithUTF8String:name];
        
        // 获取方法的参数列表
        int arguments = method_getNumberOfArguments(method);
        NSLog(@"方法名: %@ , 参数个数: %d",methodName, arguments);
    }
    
    // 记得释放
    free(methods);
}


#pragma mark - 获取对象的成员变量
- (NSArray *)allMemberVariables
{
    // 要获取对象的成员变量，可以通过class_copyIvarList方法来获取，通过ivar_getName来获取成员变量的名称。对于属性，会自动生成一个成员变量。
    // Ivar：成员属性的意思
    // 第一个参数：表示获取哪个类中的成员属性
    // 第二个参数：表示这个类有多少成员属性，传入一个Int变量地址，会自动给这个变量赋值
    // 返回值Ivar *：指的是一个ivar数组，会把所有成员属性放在一个数组中，通过返回的数组就能全部获取到。
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < count; i++) {
        Ivar variable = ivars[i];
        
        const char *name = ivar_getName(variable);
        NSString *varName = [NSString stringWithUTF8String:name];
        
        [results addObject:varName];
    }
    
    free(ivars);
    
    return results;
}

@end
