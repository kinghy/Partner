//
//  STOProductSellViewController.m
//  Partner
//
//  Created by  rjt on 15/11/25.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductSellViewController.h"
#import "STOProductSellMarketBll.h"

@interface STOProductSellViewController ()
@property (strong, nonatomic) STOProductSellMarketBll *marketBll;
@end

@implementation STOProductSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
-(void)initBll{
    self.marketBll = [STOProductSellMarketBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.mainTable}];
}

@end
