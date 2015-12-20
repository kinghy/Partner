//
//  AppParam.h
//  EasyFrame
//
//  Created by  rjt on 15/6/16.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import "EFConnectorParam.h"

@interface AppParam : EFConnectorParam
@property (strong,nonatomic) NSArray* filterErrorCodes;//过滤错误代码，NSNumber类型，在队列中得错误代码，系统框架将不会给出错误提示框，需要上层应用自行捕捉
@end
