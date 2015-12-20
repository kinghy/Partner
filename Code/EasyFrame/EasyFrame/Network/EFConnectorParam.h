/*!
 @header EFConnectorParam.h
 @abstract 网络请求参数基类
 @author kinghy
 @version 1.00
 @Copyright (c) 2015年 交易支点. All rights reserved.
 */
#import <Foundation/Foundation.h>

#define kMethodGet @"GET"
#define kMethodPost @"POST"

/*!
 *  @class  EFConnectorParam
 *  @brief 网络请求参数基类
 */
@interface EFConnectorParam : NSObject{
    NSString *_url;
    NSString *_method;
    NSDictionary *_headers;
    Class _cls;
}


/*!
 *  @brief  获取网络请求地址(子类实现)
 *
 *  @return 返回网络请求地址
 */
- (NSString*)getOperatorType;
/*!
 *  @brief  获取网络请求地址翻译，主要用来拼接域名等(子类实现)
 *
 *  @return 返回翻译后的网络请求地址
 */
- (NSString*)getOperatorTypeTranslate;

/*!
 *  @brief  获取网络请求类型(子类实现)
 *
 *  @return 返回网络请求类型，get/post
 */
-(NSString*)getMethod;//网络请求类型

/*!
 *  @brief  获取网络接口容器(子类实现)
 *
 *  @return 返回网络接口容器类型
 */
-(Class)getEntityClass;

/*!
 *  @brief  网络请求超时(默认30秒)
 *
 *  @return 返回网络请求超时(默认15秒)
 */
-(double)delayRequestTimeOut;

/*!
 *  @brief  设置别名(子类实现)
 *
 *  @return 返回别名
 */
-(NSString*)getAliasName;

/*!
 *  @brief  设置访问头(子类实现)
 *
 *  @return 返回访问投
 */
-(NSDictionary*)getHeaders;

/*!
 *  @brief  构建方法
 *
 *  @return 类型对象
 */
+(instancetype)param;//构建方法

/*!
 *  @brief  快速构建方法
 *
 *  @param url     访问url
 *  @param method  访问方法
 *  @param params  访问参数
 *  @param headers 访问头信息
 *  @param entClass 接口容器类
 *
 *  @return 类型对象
 */
+(instancetype)paramWithUrl:(NSString*)url method:(NSString*)method params:(NSDictionary*)params headers:(NSDictionary*)headers entClass:(Class)cls;

/*!
 *  @brief  快速初始化方法
 *
 *  @param url     访问url
 *  @param method  访问方法
 *  @param params  访问参数
 *  @param headers 访问头信息
 *  @param entClass 接口容器类
 *
 *  @return 类型对象
 */
-(instancetype)initWithUrl:(NSString*)url method:(NSString*)method params:(NSDictionary*)params headers:(NSDictionary*)headers entClass:(Class)cls;

/*!
 *  @brief  在底层捕获错误并显示
 *
 *  @param error               NSError实例
 *  @param EFEntity            EFEntity实例
 */
-(void) catchErrors:(NSError*)error withEntity:(EFEntity*)entity;

/*!
 *  @brief  快捷参数列表
 */
@property (nonatomic,strong)  NSMutableDictionary* dict;



@end
