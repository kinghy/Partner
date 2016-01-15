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
#import "ContractsEntity.h"
#import "ContractViewModel.h"

@implementation PartnerBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"PartnerSection"] delegate:self];
    adpator.scrollEnabled = YES;
    return adpator;
}

-(void)loadBll{
    [super loadBll];
}

-(Class)typeOfModel{
    return [PartnerViewModel class];
}

-(void)bindViewModel{
    if (_viewModel) {
        PartnerViewModel* model = (PartnerViewModel*)_viewModel;
        @weakify(self)
        [RACObserve(model, seqPartner) subscribeNext:^(id x) {
            @strongify(self);
            EFAdaptor* adpator = (EFAdaptor*)self.pAdaptorDict[kBllUniqueTable];
            [adpator clear];
            [[[(RACSequence*)x signal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
                [adpator addEntity:x withSection:[PartnerSection class]];
            } completed:^{
                [adpator notifyChanged];
            }];
        }];
    }
    
}


-(void)controllerDidAppear{
   [(PartnerViewModel*)self.viewModel getPartner];
}

-(void)show{
    [super show];
    [(PartnerViewModel*)self.viewModel getPartner];
}

#pragma marks - EFAdaptorDelegate

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
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
    ContractViewController* controller = [ContractViewController controllerWithModel:[ContractViewModel viewModelWithEntity:(ContractsRecordsEntity*)entity] nibName:@"ContractViewController" bundle:[NSBundle mainBundle]];
    [self.controller.navigationController pushViewController:controller animated:YES];
}
@end
