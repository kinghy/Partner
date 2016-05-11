//
//  STOProductFreeStyleBll.m
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductFreeStyleBll.h"
#import "STOProductFreeStyleSection.h"
#import "ProductHqsEntity.h"
#import "STOSearchViewController.h"
#import "STOProductBuyOrderViewController.h"
#import "STOProductFreeStyleSection.h"
#import "STOProductFreeStyleViewModel.h"
#import "AppUtil.h"
#import "STOMyStockHeadView.h"
#import "STOMyStockListCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "STOSearchViewModel.h"
#import "STOProductBuyOrderViewModel.h"

@implementation STOProductFreeStyleBll

-(void)loadBll{
    self.manager = [STOProductManager shareSTOProductManager];
    [super loadBll];
    _viewModel = [STOProductFreeStyleViewModel viewModel];
    __weak STOProductFreeStyleViewModel* model = (STOProductFreeStyleViewModel*)_viewModel;
    isSearch = false;
    
    RACSignal* showSignal = [RACSignal combineLatest:@[[self rac_signalForSelector:@selector(show)],[self rac_signalForSelector:@selector(controllerDidAppear)]]];
    RACSignal* hideSignal = [RACSignal merge:@[[self rac_signalForSelector:@selector(hide)],[self rac_signalForSelector:@selector(controllerDidDisappear)]]];
    [showSignal subscribeNext:^(id x) {
        [model refreshHq];
        [model refreshMyStock];
        [[[RACSignal interval:kFreeStyleValue onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:hideSignal] subscribeNext:^(id x) {
            [model refreshHq];
            [model refreshMyStock];
        }];
    } ];
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adaptor = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"STOProductFreeStyleSection"] delegate:self];
    adaptor.fillParentEnabled = YES;
    [adaptor addEntity:[EFEntity entity] withSection:[STOProductFreeStyleSection class]];

    return adaptor;
}

#pragma mark - 刷新数据

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductFreeStyleSection class]]) {
        self.mySection = (STOProductFreeStyleSection*)section;
        
        [self.mySection.addMyStockBtn addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
        
        @weakify(self);
        //绑定上证指数
        __weak STOProductFreeStyleViewModel* model = (STOProductFreeStyleViewModel*)_viewModel;
        [[RACSignal combineLatest:@[RACObserve(model, indexYSH),RACObserve(model, indexSH)]] subscribeNext:^(id x) {
            RACTupleUnpack(NSNumber *indexYSH, NSNumber *indexSH) = x;
            @strongify(self);
            NSString *sign = (indexSH.floatValue>indexYSH.floatValue)?@"+":@"";
            UIColor *color = [AppUtil colorWithOpen:indexYSH.floatValue andNew:indexSH.floatValue];
            self.mySection.shLabel.text = (indexSH==nil && indexSH.floatValue==0)?@"— —":[NSString stringWithFormat:@"%.2f",indexSH.floatValue];
            self.mySection.shMinus.text = [NSString stringWithFormat:@"%@%.2f      %@%.2f%%",sign,(indexSH.floatValue-indexYSH.floatValue),sign,(indexSH.floatValue-indexYSH.floatValue)*100/indexYSH.floatValue];
            
            [self.mySection.shLabel setTextColor:color];
            [self.mySection.shMinus setTextColor:color];
        }];
        
        [[RACSignal combineLatest:@[RACObserve(model, indexYSZ),RACObserve(model, indexSZ)]] subscribeNext:^(id x) {
            RACTupleUnpack(NSNumber *indexYSZ, NSNumber *indexSZ) = x;
            @strongify(self);
            NSString *sign = (indexSZ.floatValue>indexYSZ.floatValue)?@"+":@"";
            UIColor *color = [AppUtil colorWithOpen:indexYSZ.floatValue andNew:indexSZ.floatValue];
            self.mySection.szLabel.text = (indexSZ==nil && indexSZ.floatValue==0)?@"— —":[NSString stringWithFormat:@"%.2f",indexSZ.floatValue];
            self.mySection.szMinus.text = [NSString stringWithFormat:@"%@%.2f      %@%.2f%%",sign,(indexSZ.floatValue-indexYSZ.floatValue),sign,(indexSZ.floatValue-indexYSZ.floatValue)*100/indexYSZ.floatValue];
            
            [self.mySection.szLabel setTextColor:color];
            [self.mySection.szMinus setTextColor:color];
        }];
        
        self.mySection.myStockTable.dataSource = self;
        self.mySection.myStockTable.delegate = self;
        [RACObserve(model, myStocks) subscribeNext:^(NSArray *myStocks) {
            @strongify(self);
            if (!self.mySection.myStockTable.isEditing) {
                [self.mySection.myStockTable reloadData];
                if (myStocks && myStocks.count<=0 ) {
                    self.mySection.myStockTable.hidden = YES;
                    self.mySection.addMyStoctView.hidden = NO;
                }else{
                    self.mySection.myStockTable.hidden = NO;
                    self.mySection.addMyStoctView.hidden = YES;
                }
            }
        }];
        
    }
}

-(void)searchClicked{
    
    STOSearchViewController *controller = [STOSearchViewController controllerWithModel:[STOSearchViewModel viewModel] nibName:@"STOSearchViewController" bundle:nil];
    controller.delegate = self;
    [self.controller presentViewController:controller animated:YES completion:nil];
    isSearch = YES;
}

-(void)viewController:(EFBaseViewController *)controller dismissedWithObject:(id)obj{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self goMarket:obj];
    });
    
}

-(void)goMarket:(StockEntity*)entity{
    [self.manager chooseStock:entity];
    STOProductBuyOrderViewController *controller= [STOProductBuyOrderViewController controllerWithModel:[STOProductBuyOrderViewModel viewModel] nibName:@"STOProductBuyOrderViewController" bundle:nil];
    [self.controller.navigationController pushViewController:controller animated:YES];
}


#pragma marks - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    STOProductFreeStyleViewModel* model = (STOProductFreeStyleViewModel*)_viewModel;
    return [model.myStocks count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 59;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    STOMyStockHeadView *s = [EFNibHelper loadNibNamed:@"STOMyStockHeadView" ofClass:[STOMyStockHeadView class]];
    return s;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [(STOProductFreeStyleViewModel*)self.viewModel removeMyStock:indexPath.row];
    [tableView setEditing:NO animated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifyer = @"STOMyStockListCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyer];
    if (cell == nil) {
        cell = [EFNibHelper loadNibNamed:@"STOMyStockListCell" ofClass:[STOMyStockListCell class]];
    }
    
    STOMyStockListCell* c = (STOMyStockListCell*)cell;
    STOProductFreeStyleViewModel* model = (STOProductFreeStyleViewModel*)_viewModel;
    ProductHqsRecordsEntity* hq = (ProductHqsRecordsEntity*)model.myStocks[indexPath.row];
    c.stockName.text = hq.stockname;
    c.stockCode.text = hq.stockcode;
    UIColor* color = [AppUtil colorWithOpen:[hq.YClose floatValue] andNew:[hq.New floatValue]];
    c.price.textColor = color;
    c.change.textColor = color;
    if ([hq.New floatValue]>0) {
        c.price.text = [NSString stringWithFormat:@"%.2f",[hq.New floatValue]];
        float rate = ([hq.New floatValue]-[hq.YClose floatValue])/[hq.YClose floatValue]*100;
        if (rate>0) {
            c.change.text = [NSString stringWithFormat:@"+%.2f%%",rate];
        }else{
            c.change.text = [NSString stringWithFormat:@"%.2f%%",rate];
        }
        
    }else{
        c.price.text = @"— —";
        c.change.text = @"— —";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StockEntity* entity = ((STOProductFreeStyleViewModel*)self.viewModel).myStocksEntities[indexPath.row];
    [self goMarket:entity];
}

@end