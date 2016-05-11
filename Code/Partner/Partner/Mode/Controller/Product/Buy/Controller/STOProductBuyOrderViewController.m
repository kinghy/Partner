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

@interface STOProductBuyOrderViewController ()

@end

@implementation STOProductBuyOrderViewController

-(Class)typeOfModel{
    return [STOProductBuyOrderViewModel class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    //打开定时器
    _viewModel = [STOProductBuyOrderViewModel viewModel];
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
        STOProductBuyOrderViewModel* model = (STOProductBuyOrderViewModel*)_viewModel;
        [self setNavigationTitle:model.name andCode:model.code andImg:nil showImg:NO];
    }
}

-(void)initAdaptor{
    self.pAdaptor = [EFAdaptor adaptorWithTableView:self.pTable nibArray:@[@"STOProductBuyOrderSection"] delegate:self];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[STOProductBuyOrderPriceSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[STOProductBuyOrderHandicapSection class]];
//    self.pAdaptor.fillParentEnabled = YES;
    self.pAdaptor.scrollEnabled = YES;
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

@end
