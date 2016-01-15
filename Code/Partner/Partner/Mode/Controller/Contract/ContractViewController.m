//
//  ContractViewController.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ContractViewController.h"
#import "ContractViewModel.h"
#import "ContractSection.h"
#import "ContractDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ContractViewController ()
@end

@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.title = @"合约";
    
}

-(Class)typeOfModel{
    return [ContractViewModel class];
}

-(void)initAdaptor{
    self.pAdaptor = [EFAdaptor adaptorWithTableView:self.pTable nibArray:@[@"ContractSection"] delegate:self];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[ContractSection class]];
    self.pAdaptor.fillParentEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[ContractSection class]]) {
        ContractSection* s = (ContractSection*)section;
        ContractViewModel *model = (ContractViewModel*)_viewModel;
        
        RAC(s.marketName,text) = RACObserve(model, marketName);
        RAC(s.money,text) = RACObserve(model, money);
        RAC(s.limit,text) = RACObserve(model, limit);
        RAC(s.rate,text) = RACObserve(model, rate);
        RAC(s.allocation,text) = RACObserve(model, allocation);
        
        //监视点击事件结果
        __block MBProgressHUD* hud = nil;
        @weakify(self); 
        s.confirmBtn.rac_command = model.nextCmd;
        [s.confirmBtn.rac_command.errors subscribeNext:^(id x) {
            [hud hide:YES];
        }];
        [s.confirmBtn.rac_command.executionSignals subscribeNext:^(id x) {
            @strongify(self);
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        }];

        [[s.confirmBtn.rac_command.executionSignals flatten] subscribeNext:^(id x) {
            [hud hide:YES];
            @strongify(self);
            ContractDetailViewController *ctrl = [[ContractDetailViewController alloc] init];
            [self.navigationController pushViewController:ctrl animated:YES];
        }];
    }
}

@end
