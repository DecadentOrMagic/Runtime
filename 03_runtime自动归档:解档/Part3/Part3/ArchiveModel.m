//
//  ArchiveModel.m
//  Part3
//
//  Created by 薛尧 on 16/9/20.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import "ArchiveModel.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation ArchiveModel

// 遵守了NSCoding协议之后，我们就可以在实现文件中实现-encodeWithCoder:方法来归档和-initWithCoder:解档。

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount = 0;
    
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        
        // 获取成员变量名
        const void * name = ivar_getName(ivar);
        NSString *ivarName = [NSString stringWithUTF8String:name];
        // 去掉成员变量的下划线(我们获取到的属性所生成的成员变量是带下划线，因此我们需要在获取到成员变量名称后，需要去掉下划线)
        ivarName = [ivarName substringFromIndex:1];
        
        // 接下来，在归档的时候我们通过属性的getter方法来获取值，然后归档。但是，成员变量是是有类型的，并不是所有类型都可以归档，比如const void *就不支持归档，那么我们需要根据类型转换成支持归档的类型再存储。
        // 获取getter方法
        SEL getter = NSSelectorFromString(ivarName);
        if ([self respondsToSelector:getter]) {
            // 通过ivar_getTypeEncoding函数获取成员变量的类型
            const void * typeEncoding = ivar_getTypeEncoding(ivar);
            NSString *type = [NSString stringWithUTF8String:typeEncoding];
            
            // const void *
            if ([type isEqualToString:@"r^v"]) {
                const char *value = ((const void * (*)(id, SEL))objc_msgSend)((id)self, getter);
                NSString *utf8Value = [NSString stringWithUTF8String:value];
                [aCoder encodeObject:utf8Value forKey:ivarName];
                continue;
            }
            
            // int
            else if ([type isEqualToString:@"i"]) {
                int value = ((int (*)(id, SEL))objc_msgSend)((id)self, getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
                continue;
            }
            
            // float
            else if ([type isEqualToString:@"f"]) {
                float value = ((float (*)(id, SEL))objc_msgSend)((id)self, getter);
                [aCoder encodeObject:@(value) forKey:ivarName];
            }
            
            id value = ((id (*)(id, SEL))(void *)objc_msgSend)((id)self, getter);
            if (value != nil && [value respondsToSelector:@selector(encodeWithCoder:)]) {
                [aCoder encodeObject:value forKey:ivarName];
            }
        }
        
    }
    
    free(ivars);
}




- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount = 0;
        
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        
        for (unsigned int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            
            // 获取成员变量名
            const void * name = ivar_getName(ivar);
            NSString *ivarName = [NSString stringWithUTF8String:name];
            // 去掉成员变量的下划线
            ivarName = [ivarName substringFromIndex:1];
            
            // 首先我们要生成setter方法，但是setter方法的生成是有规则的。若属性名称不带下划线，那么生成的setter方法就是set+属性名称，其中需要将属性名称的首字母变成大写。若属性名称带下划线，则不需要处理。
            // 生成setter格式
            NSString *setterName = ivarName;
            // 那么一定是字母开头
            // hasPrefix 判断开头是否包含; hasSuffix 判断结束是否包含
            if (![setterName hasPrefix:@"_"]) {
                NSString *firstLetter = [NSString stringWithFormat:@"%c", [setterName characterAtIndex:0]];
                setterName = [setterName substringFromIndex:1];
                setterName = [NSString stringWithFormat:@"%@%@",firstLetter.uppercaseString, setterName];
            }
            setterName = [NSString stringWithFormat:@"set%@",setterName];
            
            // 获取setter方法
            SEL setter = NSSelectorFromString(setterName);
            if ([self respondsToSelector:setter]) {
                const void *typeEncoding = ivar_getTypeEncoding(ivar);
                NSString *type = [NSString stringWithUTF8String:typeEncoding];
                NSLog(@"%@",type);
                
                // const void *
                if ([type isEqualToString:@"r^v"]) {
                    NSString *value = [aDecoder decodeObjectForKey:ivarName];
                    if (value) {
                        ((void (*)(id, SEL, const void *))objc_msgSend)(self, setter, value.UTF8String);
                    }
                    continue;
                }
                
                // int
                else if ([type isEqualToString:@"i"]) {
                    NSNumber *value = [aDecoder decodeObjectForKey:ivarName];
                    if (value != nil) {
                        ((void (*)(id, SEL, int))objc_msgSend)(self, setter, [value intValue]);
                    }
                    continue;
                }
                
                // float
                else if ([type isEqualToString:@"f"]) {
                    NSNumber *value = [aDecoder decodeObjectForKey:ivarName];
                    if (value != nil) {
                        ((void (*)(id, SEL, float))objc_msgSend)(self, setter, [value floatValue]);
                    }
                    continue;
                }
                
                // object
                id value = [aDecoder decodeObjectForKey:ivarName];
                if (value != nil) {
                    ((void (*)(id, SEL, id))objc_msgSend)(self, setter, value);
                }
                
            }
            
        }
        
        free(ivars);
    }
    
    return self;
}


+ (void)test
{
    ArchiveModel *archiveModel = [[ArchiveModel alloc] init];
    archiveModel.archive = @"薛尧学习自动归档解档";
    archiveModel.session = "wonderful";
    archiveModel.totalCount = @(123);
    archiveModel.referenceCount = 10;
    archiveModel._floatValue = 10.0;
    
    NSString *path = NSHomeDirectory();
    path = [NSString stringWithFormat:@"%@/archive",path];
    NSLog(@"%@",path);
    [NSKeyedArchiver archiveRootObject:archiveModel toFile:path];
    
    ArchiveModel *unarchiveModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    NSLog(@"%@",unarchiveModel);
}

@end
