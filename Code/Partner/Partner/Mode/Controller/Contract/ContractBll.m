//
//  ContractBll.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ContractBll.h"
#import "ContractSection.h"
#import "ContractManager.h"
#import "ContractDetailViewController.h"

@implementation ContractBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"ContractSection"] delegate:self];
    [adpator addEntity:[ContractManager shareContractManager].selectedContract withSection:[ContractSection class]];
    adpator.fillParentEnabled = YES;
    return adpator;
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{

}

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[ContractSection class]]) {
        ContractSection* s = (ContractSection*)section;
        [s.confirmBtn addTarget:self action:@selector(confirmClicked:) forControlEvents:UIControlEventTouchDown];
        
        ContractsRecordsEntity* e = (ContractsRecordsEntity*)entity;
        s.marketName.text = e.marketName;
        s.money.text = [NSString stringWithFormat:@"%.0f万元",[e.amount floatValue]/10000];
        s.limit.text = [NSString stringWithFormat:@"%@交易日",e.period] ;
        s.rate.text = [NSString stringWithFormat:@"%d%%",[e.securityDeposit integerValue]*10];
        s.allocation.text = [NSString stringWithFormat:@"%d:%d",[e.profitAllocation integerValue]*10,100-[e.profitAllocation integerValue]*10];
    }
}

-(void)confirmClicked:(id)obj{
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.controller.view animated:YES];
    [[ContractManager shareContractManager] createDocument:^(EFEntity *entity, NSError *error) {
        [hud hide:YES];
        if (error==nil && entity) {
            ContractDetailViewController *ctrl = [[ContractDetailViewController alloc] init];
            [self.controller.navigationController pushViewController:ctrl animated:YES];
        }
        
    }];
}

@end
