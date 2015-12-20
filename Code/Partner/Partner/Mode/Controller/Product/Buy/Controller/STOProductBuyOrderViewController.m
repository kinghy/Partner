//
//  STOProductBuyOrderViewController.m
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductBuyOrderViewController.h"
#import "STOProductBuyOrderBll.h"

@interface STOProductBuyOrderViewController ()
@property (strong, nonatomic) STOProductBuyOrderBll *orderBll;

@end

@implementation STOProductBuyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"市价买入";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBll{
    self.orderBll = [STOProductBuyOrderBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.pTable}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
