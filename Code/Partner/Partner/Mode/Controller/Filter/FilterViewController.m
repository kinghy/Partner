//
//  FilterViewController.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterSection.h"
#import "ProductEntity.h"

@interface FilterViewController ()

- (IBAction)cancelClicked:(id)sender;

@property (weak,nonatomic) FilterMarketSection *marketSection;
@property (weak,nonatomic) FilterMoneySection *moneySection;

@property (weak,nonatomic) FilterLimitSection *limitSection;
@property (weak,nonatomic) FilterAllocationSection *alloSection;
@property (weak,nonatomic) FilterRateSection *rateSection;
@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleDefault;
    self.title = @"筛选";
    
    [self setRightNavBarWithTitle:@"取消" titleColor:kColorNavBarSwitchButton action:@selector(doBack)];

    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBll{
    self.pAdaptor = [EFAdaptor adaptorWithTableView:self.pTable nibArray:@[@"FilterSection"] delegate:self];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[FilterMarketSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[FilterMoneySection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[FilterLimitSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[FilterAllocationSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[FilterRateSection class]];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[FilterResetSection class]];
    self.pAdaptor.scrollEnabled = YES;
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
    if ([section isKindOfClass:[FilterMarketSection class]]) {
        self.marketSection= (FilterMarketSection*)section;
    }
    if ([section isKindOfClass:[FilterMoneySection class]]) {
        self.moneySection = (FilterMoneySection*)section;
    }
    if ([section isKindOfClass:[FilterLimitSection class]]) {
        self.limitSection = (FilterLimitSection*)section;
    }
    if ([section isKindOfClass:[FilterAllocationSection class]]) {
        self.alloSection = (FilterAllocationSection*)section;
    }
    if ([section isKindOfClass:[FilterRateSection class]]) {
        self.rateSection = (FilterRateSection*)section;

    }
    if ([section isKindOfClass:[FilterResetSection class]]) {
        FilterResetSection *s = (FilterResetSection*)section;
        [s.reset addTarget:self action:@selector(resetAllBtn) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)resetAllBtn{
    [self.marketSection resetAllBtn];
    [self.moneySection resetAllBtn];
    [self.limitSection resetAllBtn];
    [self.alloSection resetAllBtn];
    [self.rateSection resetAllBtn];
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doBack{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
