//
//  PropertyLearn.h
//  Part7
//
//  Created by 薛尧 on 16/10/7.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyLearn : NSObject
{
    float _privateName;
    float _privateAttribute;
}

@property (nonatomic, copy  ) NSString *title;
@property (nonatomic, strong) NSArray  *names;
@property (nonatomic, assign) int      count;
@property (nonatomic, weak  ) id       delegate;
@property (nonatomic, strong) NSNumber *atomicProperty;

+ (void)test;

@end
