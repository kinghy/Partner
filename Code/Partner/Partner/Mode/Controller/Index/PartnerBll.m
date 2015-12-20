//
//  PartnerBll.m
//  Partner
//
//  Created by kinghy on 15/10/1.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "PartnerBll.h"
#import "PartnerSection.h"
#import "ProductEntity.h"
#import "ContractViewController.h"
#import "IndexViewController.h"
#import "ContractManager.h"
#import "ContractsEntity.h"

@implementation PartnerBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"PartnerSection"] delegate:self];
    adpator.scrollEnabled = YES;
    return adpator;
}

-(void)loadBll{
    [super loadBll];
}

-(void)getContract{
    DEFINED_WEAK_SELF
    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.controller.view animated:YES];
    [[ContractManager shareContractManager] filterContract:^(EFEntity *entity, NSError *error) {
        [hud hide:YES];
        ContractsEntity* e = (ContractsEntity*)entity;
        if (error==nil && e && e.records.count>0) {
            EFAdaptor* adpator = (EFAdaptor*)_self.pAdaptorDict[@"kBllUniqueTable"];
            [adpator clear];
            for (int i=0; i<e.records.count; ++i) {
                [adpator addEntity:e.records[i] withSection:[PartnerSection class]];
            }
            [adpator notifyChanged];
            
        }
    }];
}

-(void)controllerDidAppear{
   [self getContract]; 
}

-(void)show{
    [super show];
    [self getContract];
}

#pragma marks - EFAdaptorDelegate
-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isMemberOfClass:[PartnerSection class]]) {
        ContractsRecordsEntity* e = (ContractsRecordsEntity*)entity;
        PartnerSection* s = (PartnerSection*)section;
        s.title.text = e.marketName;
        s.investMoney.text = [NSString stringWithFormat:@"%.0f万元",[e.amount floatValue]/10000];
        s.investLimit.text = [NSString stringWithFormat:@"%@交易日",e.period] ;
        s.bailRate.text = [NSString stringWithFormat:@"%ld%%",[e.securityDeposit integerValue]*10];
        s.earnest.text = [NSString stringWithFormat:@"%ld:%ld",[e.profitAllocation integerValue]*10,100-[e.profitAllocation integerValue]*10];
        s.nickname.text = e.investorName;
        s.logo.layer.cornerRadius = s.logo.frame.size.width/2;
        s.logo.layer.borderColor = Color_Bg_757575.CGColor;
        s.logo.layer.borderWidth = 1.f;
        s.logo.clipsToBounds = YES;
        
        //        s.logo.image = [UIImage imageNamed:e.logo];
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity{
    ContractViewController* controller = [[ContractViewController alloc] init];
    [ContractManager shareContractManager].selectedContract = (ContractsEntity*)entity;
    [self.controller.navigationController pushViewController:controller animated:YES];
}
@end
