//
//  STOSearchViewController.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/9.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "STOSearchViewController.h"
#import "IndexViewController.h"
#import "STOSearchViewModel.h"
#import "UIBarButtonItem+YL.h"
#import "STODBManager.h"
#import "STOStockListSection.h"

@interface STOSearchViewController ()<UITextFieldDelegate> 

@end

@implementation STOSearchViewController
-(Class)typeOfModel{
    return [STOSearchViewModel class];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航条
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    
    self.title = @"选择股票";
    [super viewDidLoad];
    
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden=YES;
    
    self.searchView.layer.cornerRadius = 3;
    self.searchView.layer.borderWidth = 1;
    self.searchView.layer.borderColor = kColorSearchBorder.CGColor;
    
}

-(void)initAdaptor{
    self.pAdaptor = [EFAdaptor adaptorWithTableView:self.pTable nibArray:@[@"STOStockListSection"] delegate:self];
    self.pAdaptor.scrollEnabled = YES;
}

-(void)bindViewModel{
    if (_viewModel) {
        @weakify(self);
        STOSearchViewModel* model = (STOSearchViewModel*)_viewModel;
        RAC(model, searchText) = self.search.rac_textSignal;
        RAC(self.search,text) = [RACObserve(model, searchText) distinctUntilChanged];
        
        self.cancelBtn.rac_command = model.cancelCmd;
        [[self.cancelBtn.rac_command executionSignals] subscribeNext:^(id x) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [RACObserve(model, searchStocks) subscribeNext:^(id x) {
            @strongify(self);
            [self.pAdaptor clear];
            [[[(RACSequence*)x signal] deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(EFEntity* entity) {
                @strongify(self);
                [self.pAdaptor addEntity:entity withSection:[STOStockListSection class]];
            } completed:^{
                @strongify(self);
                [self.pAdaptor notifyChanged];
            }];
        }];
    }
}

- (void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isMemberOfClass:[STOStockListSection class]]) {
        STOStockListSection *s = (STOStockListSection *)section;
        StockEntity *e = (StockEntity *)entity;
        s.stockNameLab.text = e.stockName;
        s.stockCodeLab.text = e.stockCode;
        s.addBtn.tag = entity.tag;
        [s.addBtn addTarget:self action:@selector(addMyStock:) forControlEvents:UIControlEventTouchUpInside];
        if ([e.choosed boolValue]) {
            [s.addBtn setImage:[UIImage imageNamed:@"mydelbtn"] forState:UIControlStateNormal];
        }else{
            [s.addBtn setImage:[UIImage imageNamed:@"myaddbtn"] forState:UIControlStateNormal];
        }
    }
}

-(void)addMyStock:(UIButton*)btn{
    [(STOSearchViewModel*)self.viewModel addMyStock:btn.tag];
}

////#pragma mark - 点击选择section
- (void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity
{
    if ([section isMemberOfClass:[STOStockListSection class]]) {
        [self dismissViewControllerAnimated:NO userObj:entity completion:nil];
    }
}



@end
