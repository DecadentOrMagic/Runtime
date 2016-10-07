//
//  ArchiveModel.h
//  Part3
//
//  Created by 薛尧 on 16/9/20.
//  Copyright © 2016年 薛尧. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArchiveModel : NSObject <NSCoding>

// 我们这里只处理了普通的几种类型，这里只测试int、NSString、const void *、NSNumber、float类型。对于const void *是不支持kvc的，因此我们是不能通过kvc完成的，但是我们可以通过runtime发送消息实现。

@property (nonatomic, assign) int          referenceCount;
@property (nonatomic, copy)   NSString     *archive;
@property (nonatomic, assign) const void * session;
@property (nonatomic, strong) NSNumber     *totalCount;
// 注意,这里只是为了测试一下属性使用下滑线的情况
@property (nonatomic, assign) float        _floatValue;

+ (void)test;

@end
