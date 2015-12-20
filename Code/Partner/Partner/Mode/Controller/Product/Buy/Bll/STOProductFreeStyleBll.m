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
#import "STOProductMarketViewController.h"
#import "STOProductFreeStyleSection.h"
#import "STOProductFreeStyleViewModel.h"
#import "AppUtil.h"
#import "STOMyStockHeadView.h"
#import "STOMyStockListCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation STOProductFreeStyleBll

-(void)loadBll{
    self.manager = [STOProductManager shareSTOProductManager];
    [super loadBll];
    self.viewModel = [STOProductFreeStyleViewModel viewModel];
    isSearch = false;
    [self.viewModel refreshHq];
    @weakify(self);
    RACSignal* showSignal = [RACSignal combineLatest:@[[self rac_signalForSelector:@selector(show)],[self rac_signalForSelector:@selector(controllerDidAppear)]]];
    [showSignal subscribeNext:^(id x) {
        @strongify(self);
        RACSignal* hideSignal = [RACSignal merge:@[[self rac_signalForSelector:@selector(hide)],[self rac_signalForSelector:@selector(controllerDidDisappear)]]];
        [[[RACSignal interval:kFreeStyleValue onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:hideSignal] subscribeNext:^(id x) {
            @strongify(self);
            DDLogInfo(@"kFreeStyleValue");
            [self.viewModel refreshHq];
            [self.viewModel refreshMyStock];
            
        }];
    }];
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adaptor = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"STOProductFreeStyleSection"] delegate:self];
    [adaptor addEntity:[EFEntity entity] withSection:[STOProductFreeStyleSection class]];
    return adaptor;
}

#pragma mark - 刷新数据

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[STOProductFreeStyleSection class]]) {
        self.mySection = (STOProductFreeStyleSection*)section;
        [self.mySection.searchBtn addTarget:self action:@selector(searchClicked) forControlEvents:UIControlEventTouchUpInside];
        @weakify(self);
        //绑定上证指数
        
        [[RACSignal combineLatest:@[RACObserve(_viewModel, indexYSH),RACObserve(_viewModel, indexSH)]] subscribeNext:^(id x) {
            RACTupleUnpack(NSNumber *indexYSH, NSNumber *indexSH) = x;
            @strongify(self);
            NSString *sign = (indexSH.floatValue>indexYSH.floatValue)?@"+":@"";
            UIColor *color = [AppUtil colorWithOpen:indexYSH.floatValue andNew:indexSH.floatValue];
            self.mySection.shLabel.text = (indexSH==nil && indexSH.floatValue==0)?@"— —":[NSString stringWithFormat:@"%.2f",indexSH.floatValue];
            self.mySection.shMinus.text = [NSString stringWithFormat:@"%@%.2f      %@%.2f%%",sign,(indexSH.floatValue-indexYSH.floatValue),sign,(indexSH.floatValue-indexYSH.floatValue)*100/indexYSH.floatValue];
 
            [self.mySection.shLabel setTextColor:color];
            [self.mySection.shMinus setTextColor:color];
        }];
        
        [[RACSignal combineLatest:@[RACObserve(_viewModel, indexYSZ),RACObserve(_viewModel, indexSZ)]] subscribeNext:^(id x) {
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
        [RACObserve(_viewModel, myStocks) subscribeNext:^(id x) {
            @strongify(self);
            [self.mySection.myStockTable reloadData];
        }];
    }
}

-(void)searchClicked{
    STOSearchViewController *controller = [[STOSearchViewController alloc] init];
    [self.controller presentViewController:controller animated:YES completion:nil];
    isSearch = YES;
}

-(void)controllerWillAppear{
    if (![self isHidden]) {
        if (self.manager.chosedStock && isSearch) {
            isSearch = false;
            STOProductMarketViewController *controller= [[STOProductMarketViewController alloc] init];
            [self.controller.navigationController pushViewController:controller animated:NO];
        }
    }
}


#pragma marks - UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.myStocks count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    STOMyStockHeadView *s = [EFNibHelper loadNibNamed:@"STOMyStockHeadView" ofClass:[STOMyStockHeadView class]];
    return s;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellIdentifyer = @"STOMyStockListCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyer];
    if (cell == nil) {
        cell = [(UITableViewCell*)[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyer];
        STOMyStockListCell *cell = [EFNibHelper loadNibNamed:@"STOMyStockListCell" ofClass:[STOMyStockListCell class]];
    }
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.viewModel.selectContract =  self.viewModel.contracts[indexPath.row];
//    [self closeContractClicked];
//}

@end
