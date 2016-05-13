//
//  STOProductBuyOrderViewController.m
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductBuyOrderViewController.h"
#import "STOProductBuyOrderViewModel.h"
#import "STOProductBuyOrderSection.h"
#import "ContractsEntity.h"

@interface STOProductBuyOrderViewController ()
@property (weak, nonatomic) IBOutlet EFTableView *contractTable;
@property (strong, nonatomic)  EFAdaptor *contractAdapor;
//@property (weak, nonatomic)  EFAdaptor *contractAdapor;
- (IBAction)contractsClicked:(id)sender;
@end

@implementation STOProductBuyOrderViewController

-(Class)typeOfModel{
    return [STOProductBuyOrderViewModel class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.contractTable.hidden = YES;
    self.contractTable.layer.shadowRadius =  7;
    self.contractTable.layer.shadowOpacity = 0.7f;
    self.contractTable.layer.shadowOffset = CGSizeMake(0,-7);
    self.contractTable.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contractTable.layer.masksToBounds = NO ;//显示阴影必须关闭
    //打开定时器
    [(STOProductBuyOrderViewModel*)_viewModel getHqData];
    
    @weakify(self);
    [[[[self rac_signalForSelector:@selector(viewDidAppear:)] take:1] then:^RACSignal *{
        @strongify(self)
        return [[RACSignal interval:kOrderHqOnceTaskVal onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[self rac_signalForSelector:@selector(viewWillDisappear:)]];
    }] subscribeNext:^(id x) {
        @strongify(self)
        [(STOProductBuyOrderViewModel*)self.viewModel getHqData];
    }];
}

-(void)bindViewModel{
    if (_viewModel) {
        @weakify(self);

        STOProductBuyOrderViewModel* model = (STOProductBuyOrderViewModel*)_viewModel;
        [self setNavigationTitle:model.name andCode:model.code andImg:nil showImg:NO];

        [RACObserve(model,contracts) subscribeNext:^(id x) {
            @strongify(self)
            NSArray *contracts = (NSArray*)x;
            if (contracts) {
                [self.contractAdapor clear];
                [self.contractAdapor addEntity:[EFEntity entity] withSection:[STOProductContractsHeaderSection class]];
                for (ContractsRecordsEntity *e in contracts) {
                    [self.contractAdapor addEntity:e withSection:[STOProductContractsListSection class]];
                }
                [self.contractAdapor notifyChanged];
            }
            
        }];
        
        [RACObserve(model,selectContract) subscribeNext:^(ContractsRecordsEntity* entity) {
            @strongify(self);
            if(entity){
                [self.contractAdapor notifyChanged];
                [self.pAdaptor notifyChanged];
            }
        }];
    }
}

-(void)initAdaptor{
    self.pAdaptor = [EFAdaptor adaptorWithTableView:self.pTable nibArray:@[@"STOProductBuyOrderSection"] delegate:self];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[STOProductBuyOrderPriceSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[STOProductBuyOrderHandicapSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[STOProductBuyOrderSplitSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[STOProductBuyOrderContractSection class]];
    self.pAdaptor.scrollEnabled = YES;
    
    self.contractAdapor = [EFAdaptor adaptorWithTableView:self.contractTable nibArray:@[@"STOProductBuyOrderSection"] delegate:self];
    [self.contractAdapor addEntity:[EFEntity entity] withSection:[STOProductContractsHeaderSection class]];
    self.contractAdapor.scrollEnabled = YES;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma EFAdaptor - delegate
-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if([section isKindOfClass:[STOProductBuyOrderPriceSection class]]){
        __weak STOProductBuyOrderPriceSection* s = (STOProductBuyOrderPriceSection*)section;
        __weak STOProductBuyOrderViewModel* model = (STOProductBuyOrderViewModel*)self.viewModel;
        RAC(s.currentPrice,text) = RACObserve(model, currentPrice);
        RAC(s.currentPrice,textColor) = RACObserve(model, currentPriceColor);

        RAC(s.rhythmLab,textColor) = RACObserve(model, currentPriceColor);
        RAC(s.percentLab,textColor) = RACObserve(model, currentPriceColor);
        
        RAC(s.rhythmLab,text) = RACObserve(model, rhythm);
        RAC(s.percentLab,text) = RACObserve(model, precent);
        RAC(s.openLab,text) = RACObserve(model, openPrice);
        RAC(s.closeLab,text) = RACObserve(model, closePrice);
        RAC(s.highestLab,text) = RACObserve(model, highPrice);
        RAC(s.lowestLab,text) = RACObserve(model, lowPrice);
        
        RAC(s.openLab,textColor) = RACObserve(model, openPriceColor);
        RAC(s.closeLab,textColor) = RACObserve(model, closePriceColor);
        RAC(s.highestLab,textColor) = RACObserve(model, highPriceColor);
        RAC(s.lowestLab,textColor) = RACObserve(model, lowPriceColor);
    }
    
    if([section isKindOfClass:[STOProductBuyOrderHandicapSection class]]){
        __weak STOProductBuyOrderHandicapSection* s = (STOProductBuyOrderHandicapSection*)section;
        __weak STOProductBuyOrderViewModel* model = (STOProductBuyOrderViewModel*)self.viewModel;
        
       	RAC(s.sell1Lab,text)	=	RACObserve(model,	sell1);
        RAC(s.sell2Lab,text)	=	RACObserve(model,	sell2);
        RAC(s.sell3Lab,text)	=	RACObserve(model,	sell3);
        RAC(s.sell4Lab,text)	=	RACObserve(model,	sell4);
        RAC(s.sell5Lab,text)	=	RACObserve(model,	sell5);
        
        RAC(s.buy1Lab,text)	=	RACObserve(model,	buy1);
        RAC(s.buy2Lab,text)	=	RACObserve(model,	buy2);
        RAC(s.buy3Lab,text)	=	RACObserve(model,	buy3);
        RAC(s.buy4Lab,text)	=	RACObserve(model,	buy4);
        RAC(s.buy5Lab,text)	=	RACObserve(model,	buy5);
        
        RAC(s.sell1VolLab,text)	=	RACObserve(model,	sell1Vol);
        RAC(s.sell2VolLab,text)	=	RACObserve(model,	sell2Vol);
        RAC(s.sell3VolLab,text)	=	RACObserve(model,	sell3Vol);
        RAC(s.sell4VolLab,text)	=	RACObserve(model,	sell4Vol);
        RAC(s.sell5VolLab,text)	=	RACObserve(model,	sell5Vol);
        
        RAC(s.buy1VolLab,text)	=	RACObserve(model,	buy1Vol);
        RAC(s.buy2VolLab,text)	=	RACObserve(model,	buy2Vol);
        RAC(s.buy3VolLab,text)	=	RACObserve(model,	buy3Vol);
        RAC(s.buy4VolLab,text)	=	RACObserve(model,	buy4Vol);
        RAC(s.buy5VolLab,text)	=	RACObserve(model,	buy5Vol);
        
        RAC(s.sell1Lab,textColor)	=	RACObserve(model,	sell1Color);
        RAC(s.sell2Lab,textColor)	=	RACObserve(model,	sell2Color);
        RAC(s.sell3Lab,textColor)	=	RACObserve(model,	sell3Color);
        RAC(s.sell4Lab,textColor)	=	RACObserve(model,	sell4Color);
        RAC(s.sell5Lab,textColor)	=	RACObserve(model,	sell5Color);
        
        RAC(s.buy1Lab,textColor)	=	RACObserve(model,	buy1Color);
        RAC(s.buy2Lab,textColor)	=	RACObserve(model,	buy2Color);
        RAC(s.buy3Lab,textColor)	=	RACObserve(model,	buy3Color);
        RAC(s.buy4Lab,textColor)	=	RACObserve(model,	buy4Color);
        RAC(s.buy5Lab,textColor)	=	RACObserve(model,	buy5Color);
    }
}


-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductContractsListSection class]]) {
        STOProductContractsListSection *s = (STOProductContractsListSection*)section;
        ContractsRecordsEntity *e = (ContractsRecordsEntity*)entity;
        s.titleLabel.text = e.contractNo;
        s.limitLabel.text = [NSString stringWithFormat:@"%.0f万",[e.amount floatValue]/10000 ];
        if (((STOProductBuyOrderViewModel*)self.viewModel).selectContract == e) {
            s.selectedImg.hidden = NO;
        }else{
            s.selectedImg.hidden = YES;
        }
    }
    
    if ([section isKindOfClass:[STOProductBuyOrderContractSection class]]) {
        STOProductBuyOrderContractSection *s = (STOProductBuyOrderContractSection*)section;
        ContractsRecordsEntity *e = ((STOProductBuyOrderViewModel*)self.viewModel).selectContract;
        if (e) {
            s.partnerLabel.text = e.investorName;
//            s.remindFundLabel.text = e.;
//            s.rateLabel.text = e.;
//            s.minMoneyLabel.text = e.;
            s.targetLabel.text = [NSString stringWithFormat:@"%.0f万",[e.amount floatValue]/10000 ];;
//            s.deadLineLabel.text = e.;
            s.dueLabel.text = e.period;
        }
        
        
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductContractsListSection class]]) {
        ((STOProductBuyOrderViewModel*)_viewModel).selectContract =  (ContractsRecordsEntity*)entity;
        @weakify(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self)
            self.contractTable.hidden = YES;
        });
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setNavigationTitle:(NSString *)stockName andCode:(NSString *)stockCode andImg:(UIImage*)img showImg:(BOOL)show{
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, -10, 100, 19)];
    titleLabel.text=stockName;
    [titleLabel setFont:[UIFont systemFontOfSize:18]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    UILabel *titleCode=[[UILabel alloc]initWithFrame:CGRectMake(0, 13, 100, 15)];
    if (stockCode!=nil) {
        titleCode.text=[NSString stringWithFormat:@"%@",stockCode];
    }else{
        titleCode.text=@"";
    }
    [titleCode setFont:[UIFont systemFontOfSize:13]];
    titleCode.textAlignment=NSTextAlignmentCenter;
    titleCode.textColor=Color_Bg_Text_UnChosed_Blue;
    
    UIView *titleview=[[UIView alloc]initWithFrame:titleLabel.frame];
    [titleview addSubview:titleLabel];
    [titleview addSubview:titleCode];

    self.navigationItem.titleView = titleview;
}

- (IBAction)contractsClicked:(id)sender {
    self.contractTable.hidden = !self.contractTable.hidden;
}
@end
