//
//  MsgSend.m
//  Part2
//
//  Created by 薛尧 on 16/9/13.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import "MsgSend.h"

#import <objc/runtime.h>
#import <objc/message.h>
#import <UIKit/UIKit.h>

@implementation MsgSend


+ (void)test
{
    // MsgSend *msg = [[MsgSend alloc] init]; 在编译时，这一行代码也会转换成类似如下的代码:
    // 创建对象
    MsgSend *msg = ((MsgSend * (*)(id, SEL))objc_msgSend)((id)[MsgSend class], @selector(alloc));
    // 初始化对象
    msg = ((MsgSend * (*)(id, SEL))objc_msgSend)((id)msg, @selector(init));
    // 要发送消息给msg对象，并将创建的对象返回，那么我们需要强转函数指针类型。(MsgSend * (*)(id, SEL)这是带一个对象指针返回值和两个参数的函数指针，这样就可以调用了。
    
    
    // 1.调用无参数无返回值的方法
    ((void (*)(id, SEL))objc_msgSend)((id)msg,@selector(noArgumentsAndNoReturnValue));
    
    
    // 2.调用带一个参数但无返回值的方法
    // 同样，我们也是需要强转函数指针类型，否则会报错的。其实，只要调用runtime函数来发送消息，几乎都需要强转函数指针类型为合适的类型。
    ((void (*)(id, SEL, NSString *))objc_msgSend)((id)msg, @selector(hasArguments:),@"带一个参数但没有返回值");
    
    
    // 3.调用一个带返回值不带参数的方法
    NSString *retValue = ((NSString * (*)(id, SEL))objc_msgSend)((id)msg, @selector(noArgumentsButReturnValue));
    NSLog(@"%@", retValue);
    
    
    // 4.调用一个带参数带普通返回值的方法
    int returnValue = ((int (*)(id, SEL, NSString *, int))objc_msgSend)((id)msg, @selector(hasArguments:andReturnValue:), @"参数1", 2016);
    NSLog(@"return value is %d",returnValue);
    
    
    // 5.这个函数并不属性对象方法，因此我们不能直接调用，但是我们可以动态地添加方法到对象中，然后再发送消息
    /**
     *  class_addMethod 参数说明
     *  第一个参数 被添加方法的类
     *  第二个参数 可以理解为方法名
     *  第三个参数 实现这个方法的函数
     *  第四个参数 一个定义该函数返回值类型和参数类型的字符串
     */
    /**
     *  关于第四个参数
     *  比如：”v@:”意思就是这已是一个void类型的方法，没有参数传入。
     *  再比如 “i@:”就是说这是一个int类型的方法，没有参数传入。
     *  再再比如”i@:@”就是说这是一个int类型的方法，又一个参数传入。
     */
    // v@:r^vr^v，其中i代表返回类型int，@代表参数接收者，:代表SEL，r^v是const void *
    class_addMethod(msg.class, NSSelectorFromString(@"cStyleFunc"), (IMP)cStyleFunc, "i@:r^vr^v");
    returnValue = ((int (*)(id, SEL, const void *, const void *))objc_msgSend)((id)msg, NSSelectorFromString(@"cStyleFunc"), "参数1", "参数2");
    
    
    // 6.调用一个带浮点返回值的方法
    // 对于发送带浮点返回值类型的消息，我们可以使用objc_msgSend_fpret也可以使用objc_msgSend。根据注释说明，只是说有一些处理器上，需要使用objc_msgSend_fpret来发送带浮点返回值类型的消息。
    float retFloatValue = ((float (*)(id, SEL))objc_msgSend_fpret)((id)msg, @selector(returnFloatType));
    NSLog(@"%f",retFloatValue);
    retFloatValue = ((float (*)(id, SEL))objc_msgSend)((id)msg, @selector(returnFloatType));
    NSLog(@"%f",retFloatValue);
    
    
    // 7.调用一个带结构体返回值的方法
    // 对于返回值类型为结构体的消息，我们必须使用objc_msgSend_stret而不能直接使用objc_msgSend函数，否则会crash
    CGRect frame = ((CGRect (*)(id, SEL))objc_msgSend_stret)((id)msg, @selector(returnTypeIsStruct));
    NSLog(@"return value is %@", NSStringFromCGRect(frame));
}


#pragma mark - 1.无参数无返回值的方法
- (void)noArgumentsAndNoReturnValue
{
    // __FUNCTION__ 宏在预编译时会替换成当前的函数名称
    NSLog(@"%s was called, and it has no arguments and return value", __FUNCTION__);
}


#pragma mark - 2.带一个参数但无返回值的方法
- (void)hasArguments:(NSString *)arg
{
    NSLog(@"%s was called, and argument is %@", __FUNCTION__, arg);
}


#pragma mark - 3.带返回值不带参数的方法
- (NSString *)noArgumentsButReturnValue
{
    NSLog(@"%s was called, and return value is %@", __FUNCTION__, @"不带参数,但是带有返回值");
    return @"不带参数,但是带有返回值";
}


#pragma mark - 4.带参数带普通返回值的方法
- (int)hasArguments:(NSString *)arg andReturnValue:(int)arg1
{
    NSLog(@"%s was called, and argument is %@, return value is %d", __FUNCTION__, arg, arg1);
    return arg1;
}


#pragma mark - 5.动态添加方法再调用
int cStyleFunc(id receiver, SEL sel, const void *arg1, const void *arg2)
{
    NSLog(@"%s was called, arg1 is %@, and arg2 is %@",__FUNCTION__, [NSString stringWithUTF8String:arg1], [NSString stringWithUTF8String:arg2]);
    return 1;
}


#pragma mark - 6.带浮点返回值的方法
- (float)returnFloatType
{
    NSLog(@"%s was called, and has return value", __FUNCTION__);
    return 3.121592612321323123;
}


#pragma mark - 7.带结构体返回值的方法
- (CGRect)returnTypeIsStruct
{
    NSLog(@"%s was called", __FUNCTION__);
    return CGRectMake(0, 0, 10, 10);
}

@end
