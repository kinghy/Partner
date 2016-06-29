/*!
 @header Singleton.h 
 @abstract 用宏定义一个单例
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */

// .h
#define single_interface(class)     + (class *)share##class;

// .m
#define single_implementation(class)                  \
static class *_singleAccount = nil;                       \
                                                                            \
+ (class *)share##class                                        \
{ \
    if (_singleAccount == nil) {   \
        _singleAccount = [[self alloc]init];  \
    } \
    return _singleAccount; \
}  \
 \
+ (id)allocWithZone:(struct _NSZone *)zone  \
{  \
    static dispatch_once_t onceToken;  \
    dispatch_once(&onceToken, ^{   \
        _singleAccount = [super allocWithZone:zone];  \
    });  \
    return _singleAccount;  \
}     // 最后不要写 \   