//
//  Person.h
//  Part1
//
//  Created by 薛尧 on 16/9/8.
//  Copyright © 2016年 Dom. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  对象所有属性
 *  利用运行时获取对象的所有属性名是可以的，但是变量名获取就得用另外的方法了。我们可以通过 class_copyPropertyList 方法获取所有的属性名称。
 *  下面我们通过一个Person类来学习，这里的方法没有写成扩展，只是为了简化，将获取属性名的方法直接作为类的实例方法：
 */

@interface Person : NSObject
{
    NSString *_variableString;
}

// 默认会是什么类型呢?
@property (nonatomic, copy) NSString *name;
// 默认是strong类型
@property (nonatomic, strong) NSMutableArray *array;

/**
 *  获取对象所有属性名
 *
 *  @return 返回存放对象所有属性名的数组
 */
- (NSArray *)allProperties;

/**
 *  获取对象的所有属性名和属性值
 *
 *  @return 返回存放对象所有属性名和属性值的字典
 */
- (NSDictionary *)allPropertyNamesAndValues;

/**
 *  获取对象的所有方法名
 */
- (void)allMethods;

/**
 *  获取对象的成员变量
 *
 *  @return 返回存放对象所有成员变量的数组
 */
- (NSArray *)allMemberVariables;

@end
