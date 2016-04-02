//
//  ContractViewModel.m
//  Partner
//
//  Created by  rjt on 16/1/13.
//  Copyright © 2016年 Kinghy. All rights reserved.
//

#import "ContractViewModel.h"
#import "ContractManager.h"
#import "DocumentEntity.h"

@implementation ContractViewModel
+(instancetype)viewModelWithEntity:(ContractsRecordsEntity *)entity{
    ContractViewModel *viewModel = [self viewModel];
    viewModel.ID = entity.ID;
    viewModel.investorId = entity.investorId;
    viewModel.investorName = entity.investorName;
    viewModel.marketId = entity.marketId;
    viewModel.marketName = entity.marketName;
    viewModel.amount = entity.amount;
    viewModel.securityDeposit = entity.securityDeposit;
    viewModel.profitAllocation = entity.profitAllocation;
    viewModel.period = entity.period;
    viewModel.contractNo = entity.contractNo;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init] ;
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *returnstr=[numberFormatter stringFromNumber:[NSNumber numberWithFloat:[entity.amount floatValue]]];
    
    viewModel.money = [NSString stringWithFormat:@"%@元",returnstr];
    viewModel.limit = [NSString stringWithFormat:@"%@交易日",entity.period] ;
    viewModel.rate = [NSString stringWithFormat:@"%d%%",[entity.securityDeposit integerValue]*10];
    viewModel.allocation = [NSString stringWithFormat:@"%d:%d",[entity.profitAllocation integerValue]*10,100-[entity.profitAllocation integerValue]*10];
    return viewModel;
}

-(void)viewModelDidLoad{
    self.nextCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [[ContractManager shareContractManager] createDocument:^(EFEntity *entity, NSError *error) {
            if (error==nil && [entity isKindOfClass:[DocumentEntity class]]) {
                [subscriber sendNext:entity];
                [subscriber sendCompleted];
            }else {
                [subscriber sendError:error];
            }
        }];
            return nil;
        }];
        
    }];
}

@end
