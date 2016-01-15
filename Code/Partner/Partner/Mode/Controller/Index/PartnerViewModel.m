//
//  PartnerViewModel.m
//  Partner
//
//  Created by  rjt on 16/1/12.
//  Copyright © 2016年 Kinghy. All rights reserved.
//

#import "PartnerViewModel.h"
#import "ContractManager.h"

@implementation PartnerViewModel
-(void)getPartner{
    @weakify(self)
//    MBProgressHUD *hud =[MBProgressHUD showHUDAddedTo:self.controller.view animated:YES];
    [[ContractManager shareContractManager] filterContract:^(EFEntity *entity, NSError *error) {
        @strongify(self);
//        [hud hide:YES];
        ContractsEntity* e = (ContractsEntity*)entity;
        if (error==nil && e && e.records.count>0) {
//            EFAdaptor* adpator = (EFAdaptor*)_self.pAdaptorDict[@"kBllUniqueTable"];
//            [adpator clear];
//            for (int i=0; i<e.records.count; ++i) {
//                [adpator addEntity:e.records[i] withSection:[PartnerSection class]];
//            }
//            [adpator notifyChanged];
            self.seqPartner = e.records.rac_sequence;
        }
    }];
}
@end
