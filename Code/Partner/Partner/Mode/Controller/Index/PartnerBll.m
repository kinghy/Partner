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
    [adpator addEntity:[EFEntity entity] withSection:[PartnerHeadSection class]];
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
            [adpator.pSources removeSectionByClass:[PartnerListSection class]];
            [[[(RACSequence*)x signal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
                [adpator addEntity:x withSection:[PartnerListSection class]];
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
    if ([section isMemberOfClass:[PartnerListSection class]]) {
        ContractsRecordsEntity* e = (ContractsRecordsEntity*)entity;
        PartnerListSection* s = (PartnerListSection*)section;
        s.title.text = e.marketName;
        s.investMoney.text = [NSString stringWithFormat:@"%.0f",[e.amount floatValue]/10000];
        s.investLimit.text = [NSString stringWithFormat:@"%@交易日",e.period] ;
        s.bailRate.text = [NSString stringWithFormat:@"%d",[e.securityDeposit integerValue]*10];
        s.earnest.text = [NSString stringWithFormat:@"%d",[e.profitAllocation integerValue]*10];
    }
}


-(void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity{
    ContractViewController* controller = [ContractViewController controllerWithModel:[ContractViewModel viewModelWithEntity:(ContractsRecordsEntity*)entity] nibName:@"ContractViewController" bundle:[NSBundle mainBundle]];
    [self.controller.navigationController pushViewController:controller animated:YES];
}
@end
