//
//  STOProductBuyOrderBll.m
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductBuyOrderBll.h"
#import "STOProductBuyOrderSection.h"
#import "ProductPankouEntity.h"
#import "ContractsEntity.h"
#import "UIView+RemoveSubviews.h"
#import "AvailableCreditEntity.h"
#import "OrdersBuyEntity.h"
#import "CustomIOSAlertView.h"
#import "ContractAlert.h"
#import "STOProductBuyOrderViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation STOProductBuyOrderBll

-(void)loadBll{
    
    [super loadBll];
    CGRect rect = [UIScreen mainScreen].bounds;

    contractSection = [EFNibHelper loadNibNamed:@"STOProductBuyOrderSection" ofClass:[STOProductContractsSection class]];
    contractSection.frame = rect;
    contractSection.contractTable.dataSource = self;
    contractSection.contractTable.delegate = self;
    
    [contractSection.backBtn addTarget:self action:@selector(closeContractClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _viewModel = [STOProductBuyOrderViewModel viewModel];
    [_viewModel getHqData];
    
//    @weakify(self);
//    [[[[self.controller rac_signalForSelector:@selector(viewDidAppear:)] take:1] then:^RACSignal *{
//        @strongify(self)
//        return [[RACSignal interval:kOrderHqOnceTaskVal onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[self.controller rac_signalForSelector:@selector(viewWillDisappear:)]];
//    }] subscribeNext:^(id x) {
//        @strongify(self)
//        DDLogInfo(@"kOrderHqOnceTaskVal");
//        [self.viewModel getHqData];
//    }];
    
}

-(void)controllerWillAppear{
    @weakify(self);
    [[[RACSignal interval:kOrderHqOnceTaskVal onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[self.controller rac_signalForSelector:@selector(viewWillDisappear:)]] subscribeNext:^(id x) {
        @strongify(self)
        [self.viewModel getHqData];
    }];
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"STOProductBuyOrderSection"] delegate:self];
    [adpator addEntity:[EFEntity entity] withSection:[STOProductBuyOrderSection class]];
    adpator.fillParentEnabled = YES;
    return adpator;
}

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if([section isKindOfClass:[STOProductBuyOrderSection class]]){
        STOProductBuyOrderSection *s = (STOProductBuyOrderSection*)section;
        self.mySection = s;

        self.mySection.nameLabel.text = self.viewModel.name;
        self.mySection.codeLabel.text = self.viewModel.code;
        self.mySection.slider.minimumValue = self.viewModel.minMoney.integerValue/10000;
        self.mySection.slider.maximumValue = self.viewModel.maxMoney.integerValue/10000;
        
        RAC(_viewModel,moneyValue) =  [s.slider rac_signalForControlEvents:UIControlEventValueChanged];
        @weakify(self);
        //绑定最小值
        [RACObserve(_viewModel, minMoney) subscribeNext:^(NSNumber* value) {
            @strongify(self);
            self.mySection.minMoneyLabel.text = [NSString stringWithFormat:@"%ld万",value.integerValue/10000];
            self.mySection.slider.minimumValue = value.integerValue/10000;
        }];
        //绑定最大值
        [RACObserve(_viewModel, maxMoney) subscribeNext:^(NSNumber* value) {
            @strongify(self);
            self.mySection.maxMoneyLabel.text = [NSString stringWithFormat:@"%ld万",value.integerValue/10000];
            self.mySection.slider.maximumValue = value.integerValue/10000;
        }];
        
        RACSignal* currentValueSignal = RACObserve(_viewModel, currentValue);
        //绑定当前选择值
        [currentValueSignal subscribeNext:^(NSNumber* x) {
            @strongify(self);
            self.mySection.moneyLabel.text = [NSString stringWithFormat:@"%.0f万",x.doubleValue/10000];

        }];
        RACSignal* lastestPriceSignal = RACObserve(_viewModel, lastestPrice);
        //绑定当前价
        [lastestPriceSignal subscribeNext:^(NSNumber* x) {
            @strongify(self);
            self.mySection.priceLabel.text = [NSString stringWithFormat:@"%.2f",self.viewModel.lastestPrice.doubleValue];
            self.mySection.priceLabel.textColor = [AppUtil colorWithOpen:self.viewModel.closePrice.floatValue andNew:self.viewModel.lastestPrice. floatValue];
        }];
        //组合当前价、当前选择值，计算股数和利用率
        
        [[RACSignal combineLatest:@[currentValueSignal,lastestPriceSignal]] subscribeNext:^(RACTuple* x) {
            RACTupleUnpack(NSString *currentValue, NSString *lastestPrice) = x;
            @strongify(self);
            NSInteger num = currentValue.integerValue/lastestPrice.floatValue/100;
            num = num *100;
            self.mySection.amountLabel.text = [NSString stringWithFormat:@"%ld股（资金利用率%.2f%%）",num,(num*lastestPrice.floatValue/currentValue.floatValue)*100];
        }];
        __weak STOProductContractsSection *_section = (STOProductContractsSection*)contractSection;
        //观察合约列表是否刷新
        [RACObserve(_viewModel,contracts) subscribeNext:^(id x) {
            [_section.contractTable reloadData];
        }];
        //绑定点击打开合约
        [[self.mySection.contractBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [[UIApplication sharedApplication].keyWindow addSubview:_section];
        }];
        //绑定合约选择
        [RACObserve(_viewModel,selectContract) subscribeNext:^(ContractsRecordsEntity* entity) {
            @strongify(self);
            if(entity){
                self.mySection.contractNoLabel.text = entity.contractNo;
                self.mySection.contractNoLabel.textAlignment = NSTextAlignmentLeft;
                self.mySection.rateLabel.text =[NSString stringWithFormat:@"%ld%%",[entity.securityDeposit integerValue]*10];
                self.mySection.topLabel.text = @"20%";
            }
        }];
        
        //绑定确认按钮
        self.mySection.confirmBtn.rac_command = self.viewModel.confirmCmd;
        __block MBProgressHUD* hud = nil;
        
        [self.mySection.confirmBtn.rac_command.executionSignals subscribeNext:^(id x) {
            @strongify(self);
            hud = [MBProgressHUD showHUDAddedTo:self.controller.view animated:YES];
        }];
        
        [self.mySection.confirmBtn.rac_command.errors subscribeNext:^(NSError *error) {
            @strongify(self);
            [EFCommonFunction showNotifyHUDAtViewBottom:self.controller.view withErrorMessage:RACMsgFormError(error)];
        }];
        
        [[self.mySection.confirmBtn.rac_command.executionSignals flattenMap:^RACStream *(RACSignal *subscribeSignal) {
            return [[subscribeSignal materialize] filter:^BOOL(RACEvent *event) {
                [hud hide:YES];
                return [event.value boolValue];
            }];
        }] subscribeNext:^(id x) {
            @strongify(self);
            [self showSuccessed];
        }];
    }
}

-(void)showSuccessed{
    CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ContractAlert" owner:self options:nil];

    ContractAlert *view = (ContractAlert*)nibs[0];
    view.img.image = [UIImage imageNamed:@"contract_successed"];
    view.label.text = @"恭喜，合约签署成功！ \n 祝您投资成功！";

    view.label.numberOfLines = 0;
    // Add some custom content to the alert view
    [alertView setContainerView:view];
    // Modify the parameters
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        [alertView close];
        [self.controller.navigationController popViewControllerAnimated:YES];
    }];

    [alertView setUseMotionEffects:false];

    alertView.buttonTitles = @[@"确定"];
    [alertView show];
}

-(void)closeContractClicked{
    [contractSection removeFromSuperview];
}

#pragma marks - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.contracts count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    STOProductContractsHeaderSection *s = [EFNibHelper loadNibNamed:@"STOProductBuyOrderSection" ofClass:[STOProductContractsHeaderSection class]];
    return s;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifyer =@"STOProductContractListCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyer];
    if (cell == nil) {
        cell = [(UITableViewCell*)[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyer];
        STOProductContractsListSection *section = [EFNibHelper loadNibNamed:@"STOProductBuyOrderSection" ofClass:[STOProductContractsListSection class]];
        if (section) {
            section.frame = cell.contentView.bounds;
            [cell.contentView addSubview:section];
        }
    }
    STOProductContractsListSection *s = (STOProductContractsListSection*)cell.contentView.subviews[0];
    ContractsRecordsEntity *contractEntity = self.viewModel.contracts[indexPath.row];
    s.titleLabel.text = contractEntity.contractNo;
    s.limitLabel.text = [NSString stringWithFormat:@"%.0f万",[contractEntity.amount floatValue]/10000 ];
    if (self.viewModel.selectContract == contractEntity) {
        s.selectedImg.hidden = NO;
    }else{
        s.selectedImg.hidden = YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.viewModel.selectContract =  self.viewModel.contracts[indexPath.row];
    [self closeContractClicked];
}

@end
