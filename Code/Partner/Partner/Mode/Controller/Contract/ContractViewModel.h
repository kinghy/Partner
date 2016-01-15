//
//  ContractViewModel.h
//  Partner
//
//  Created by  rjt on 16/1/13.
//  Copyright © 2016年 Kinghy. All rights reserved.
//

#import "EFBaseViewModel.h"
#import "ContractsEntity.h"

@class RACCommand;

@interface ContractViewModel : EFBaseViewModel

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

@property (strong, nonatomic)  NSString *money;
@property (strong, nonatomic)  NSString *limit;
@property (strong, nonatomic)  NSString *rate;
@property (strong, nonatomic)  NSString *allocation;

@property (strong, nonatomic)  RACCommand* nextCmd;
//        s.rate.text = [NSString stringWithFormat:@"%d%%",[e.securityDeposit integerValue]*10];
//        s.allocation.text = [NSString stringWithFormat:@"%d:%d",[e.profitAllocation integerValue]*10,100-[e.profitAllocation

+(instancetype)viewModelWithEntity:(ContractsRecordsEntity*)entity;
@end
