/*!
 @header EFConnectorQueue.h
 @abstract 定义网络连接队列类
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */
#import <Foundation/Foundation.h>
#import "EFConnector.h"

@class EFConnectorParam;

#define kEFConnectorQueueKeyParam @"kEFConnectorQueueParamKey"
#define kEFConnectorQueueKeyBlock @"kEFConnectorQueueBlockKey"

/*!
 *  @class  EFConnectorQueue
 *  @brief 网络连接队列类
 */
@interface EFConnectorQueue : NSObject
/*!
 *  @brief  构建方法
 *
 *  @return 对象实例
 */
+(instancetype)queue;

/*!
 *  @brief  添加请求参数和回调的block
 *
 *  @param param 请求参数
 *  @param block 回调block
 */
-(void)addParam:(EFConnectorParam*)param resultBlock:(EFConnQueueRetBlock)block;

/*!
 *  @brief  根据index获取请求参数和block
 *
 *  @param index 序号
 *
 *  @return 返回param和block,key分别为kEFConnectorQueueKeyParam和kEFConnectorQueueKeyBlock
 */
-(NSDictionary*)queueAtIndex:(NSInteger)index;
/*!
 *  @brief  返回队列长度
 */
@property (readonly)  NSUInteger count;
@end
