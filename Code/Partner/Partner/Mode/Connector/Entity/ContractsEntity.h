//
//  ContractsEntity.h
//  Partner
//
//  Created by  rjt on 15/11/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AppEntity.h"

@interface ContractsEntity : AppEntity
@property (strong, nonatomic)  NSArray *records;
@end

@interface ContractsRecordsEntity : AppEntity
@property (strong, nonatomic)  NSString *ID;
@property (strong, nonatomic)  NSString *investorId;
@property (strong, nonatomic)  NSString *investorName;
@property (strong, nonatomic)  NSString *marketId;
@property (strong, nonatomic)  NSString *marketName;
@property (strong, nonatomic)  NSString *amount;//合约总价值
@property (strong, nonatomic)  NSString *securityDeposit;//保证金比例 4: 40%
@property (strong, nonatomic)  NSString *profitAllocation;//盈亏分配 4: 40 60
@property (strong, nonatomic)  NSString *period;//投资期限
@property (strong, nonatomic)  NSString *contractNo;//用户合约编号

@end
