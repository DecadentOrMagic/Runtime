//
//  PropertyLearn.m
//  Part7
//
//  Created by 薛尧 on 16/10/7.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import "PropertyLearn.h"

#import <objc/runtime.h>

@implementation PropertyLearn

#pragma mark - 获取属性的方法
- (void)getAllProperties
{
    unsigned int outCount = 0;
    // 通过class_copyPropertyList函数来获取属性列表，其中属性列表是使用@property声明的列表，对于直接使用声明为成员变量的，都不会出现在属性列表中，这也是正常的。
    objc_property_t *properties = class_copyPropertyList(self.class, &outCount);
    
    
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        // 通过runtime提供的property_getName函数来获取属性名称。(如title)
        const char *propertyName = property_getName(property);
        
        // 若要获取属性的详细描述，可通过runtime提供的property_getAttributes函数来获取。(如T@"NSString",C,N,V_title其中T是固定的.)
        const char *propertyAttributes = property_getAttributes(property);
        NSLog(@"+++++%s  %s", propertyName, propertyAttributes);
        
        
        unsigned int count = 0;
        // 若要获取属性中的objc_property_attribute_t列表，可以通过property_copyAttributeList函数来获取。
        objc_property_attribute_t *attrbutes = property_copyAttributeList(property, &count);
        for (unsigned int j = 0; j < count; j++) {
            objc_property_attribute_t attribute = attrbutes[j];
            
            // 若有获取单独的objc_property_attribute_t的name或者value，直接使用点语法即可，它是一个结构体。(通过objc_property_attribute_t结构体可以直接获取name和value)
            const char *name = attribute.name;
            const char *value = attribute.value;
            NSLog(@"-----name: %s  value :%s", name, value);
        }
        
        free(attrbutes);
    }
    
    free(properties);
}

/**
 *  详细地说明property_getAttributes获取到的属性的语义
 *
 *  1.T总是第一个，它代表类型。 对于类类型，它都是T@类型，其中@表示对象类型；对于id类型，它就是@；而对于基本数据类型，它都是T加上编码类型（@encode(type)），比如int类型就是Ti。
 *  2.表示属性编码类型，比如是C表示copy，&表示strong，W表示weak等。待会再详细地说明。若是基本类型，它默认是assign，因此此时它是空的。
 *  3.指定是nonatomic还是atomic，若是nonatomic，则用N表示，若是atomic，则值为空。比如上面的count属性的详细描述为：Ti,N,V_count，它表示int类型、nonatomic、成员变量名为_count；而上面的atomicProperty属性的详细描述为:T@NSNumber,&,V_atomicProperty，它表示类型为NSNumber且为对象类型、strong、atomic、成员变量名为_atomicProperty。
 *  4.在详细描述中，属性名称是V开头，后面跟着成员变量名称。
 */

/**
 *  详细地说明通过property_copyAttributeList所获取到的name和value
 
 title属性的详细描述T@NSString,C,N,V_title通过解析得到：
 // T的值@表示对象，"NSString"表示类型字符串
 name: T   value: @"NSString"
 // C表示copy，值为空
 name: C   value:
 // N表示nonatomic，值为空
 name: N   value:
 // V表示成员变量名
 name: V   value: _title
 
 
 count属性的详细描述Ti,N,V_count通过解析得到：
 // T的值表示基本类型，i表示int
 name: T   value: i
 // N表示nonatomic，值为空
 name: N   value:
 // V表示成员变量名，值为_count
 name: V   value: _count
 // 由于类型为基本类型，指定的是assign，它是默认的，因此所解析中并没有这个name，它会省略掉
 
 
 delegate属性的详细描述T@,W,N,V_delegate通过解析得到：
 // 我们所声明的delegate属性是id类型，因此也是类类型
 // T的值@表示对象，但是它是id类型，没有具体的类类型名称，因此为空
 name: T   value: @
 // W表示weak
 name: W   value:
 // N表示nonatomic
 name: N   value:
 // V表示成员变量名，值为_delegate
 name: V   value: _delegate
 
 
 atomicProperty属性的详细描述T@NSNumber,&,V_atomicProperty通过解析得到：
 // 声明为：
 // @property (atomic, strong) NSNumber *atomicProperty;
 
 // T的值@表示对象类型，类型为`NSNumber`
 name: T   value: @"NSNumber"
 // &表示strong类型，在MRC下表示retain
 name: &   value:
 // V表示成员变量名，值为_atomicProperty
 name: V   value: _atomicProperty
 
 // 由于它是atomic原子操作，因此没有N这个name
 */





// 通过上面的获取所有的属性，并不能获取到所有的成员变量，只能获取到声明为属性而自动创建对应的成员变量，这样是不能满足需求的，因此下面我们来学习一上成员变量。
#pragma mark - 获取成员变量的方法
- (void)getAllMemberVariables
{
    /**
     *  员变量通过Ivar表示，它是objc_ivar结构体指针：
     *  objc_ivar结构的定义为：
     
     struct objc_ivar {
         // 成员变量名
         char *ivar_name                 OBJC2_UNAVAILABLE;
         // 成员变量encode类型
         char *ivar_type                 OBJC2_UNAVAILABLE;
         // 基地址偏移字节
         int ivar_offset                 OBJC2_UNAVAILABLE;
     #ifdef __LP64__
         int space                       OBJC2_UNAVAILABLE;
     #endif
     }
     
     */
    unsigned int outCount = 0;
    Ivar *ivars = class_copyIvarList(self.class, &outCount);
    
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        const char *type = ivar_getTypeEncoding(ivar);
        
        NSLog(@"name: %s encodeType: %s", name, type);
    }
    
    free(ivars);
}





+ (void)test {
    PropertyLearn *p = [[PropertyLearn alloc] init];
//    [p getAllProperties];
    [p getAllMemberVariables];
    
    // 从打印结果可以看出来了，不管是属性定义还是直接声明为成员变量，都可以获取到变量名称。通过获取到所有的成员变量名称，那么我们就可以生成getter、setter方法，做我们想做的事情了。
}

@end
