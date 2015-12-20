//
//  OrdersBuyParam.h
//  Partner
//
//  Created by  rjt on 15/11/19.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AppParam.h"

@interface OrdersBuyParam : AppParam
@property (strong, nonatomic)  NSString *stockNo;
@property (strong, nonatomic)  NSString *amount;
@property (strong, nonatomic)  NSString *count;
@property (strong, nonatomic)  NSString *price;
@property (strong, nonatomic)  NSString *contractId;
@end
