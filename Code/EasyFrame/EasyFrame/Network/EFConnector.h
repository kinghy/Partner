/*!
 @header EFConnector.h
 @abstract 定义网络链接相关类
 @author kinghy
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */

@class EFConnectorParam,EFEntity,EFConnResult,EFConnectorQueue;

typedef void (^EFConnRetBlock)(AFHTTPRequestOperation *operation, EFEntity* entity,NSError *error);
typedef void (^EFConnQueueRetBlock)(AFHTTPRequestOperation *operation, NSOperationQueue *queue , EFEntity* entity,NSError *error);

/*!
 *  @class  EFConnector
 *  @brief 网络链接类
 */
@interface EFConnector : NSObject

/*!
 *  @brief  构建方法
 *
 *  @return 对象实例
 */
+ (instancetype)connector;

/*!
 *  @brief  异步网络请求，获取一个JSON对象
 *
 *  @param param EFConnectorParam 给定网络请求参数信息
 *  @param block 请求成功后调用
 */
- (void)run:(EFConnectorParam*)param returnBlock:(EFConnRetBlock)block;

/*!
 *  @brief  同步网络请求，获取一个JSON对象
 *
 *  @param param EFConnectorParam 给定网络请求参数信息
 *
 *  @return 返回EFConnResult类对象
 */
- (EFConnResult*)runUntilFinished:(EFConnectorParam*)param;

/*!
 *  @brief  网络队列请求
 *
 *  @param params EFConnectorQueue 网络请求参数队列
 *  @param isSeriall 是否串行执行，每个请求都依赖于队列中的前一个请求
 *  @param block  所有请求完成后调用block
 *
 */
- (void)runQueue:(EFConnectorQueue*)params seriall:(BOOL)isSeriall finishBlock:(void (^)(NSArray * operations))finishedBlock;

@end

/*!
 *  @class EFConnResult
 *  @brief 网络链接返回参数类，用于同步访问作为返回值
 */
@interface EFConnResult : NSObject
/*!
 *  @brief  AFNetWorking请求对象
 */
@property (nonatomic,strong) AFHTTPRequestOperation *operation;
/*!
 *  @brief  接口容器
 */
@property (nonatomic,strong) EFEntity* entity;
/*!
 *  @brief  错误对象
 */
@property (nonatomic,strong) NSError *error;
@end
