//
//  STOProductOrderDetailViewController.m
//  Partner
//
//  Created by  rjt on 15/11/30.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductOrderDetailViewController.h"
#import "EFNibHelper.h"
#import "STOProductOrderDetailSection.h"

@interface STOProductOrderDetailViewController ()

@end

@implementation STOProductOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易详情";
    // Do any additional setup after loading the view from its nib.
    if (self.pSection) {
        STOProductManager *manager = [STOProductManager shareSTOProductManager];
        STOProductOrderDetailSection *s = (STOProductOrderDetailSection*)self.pSection;
        s.contractNoLabel.text = manager.chosedOrder.contractNo;
        s.nameLabel.text = [NSString stringWithFormat:@"%@ %@", manager.chosedStock.stockName,manager.chosedStock.stockCode];
        float stockcount = [manager.chosedOrder.amount floatValue]/[manager.chosedOrder.price floatValue];
        s.countLabel.text = [NSString stringWithFormat:@"%.0f股",stockcount];
        s.amountLabel.text = manager.chosedOrder.amount;
        s.buyPriceLabel.text = [NSString stringWithFormat:@"%@(%@)", manager.chosedOrder.price,manager.chosedOrder.createdAt?manager.chosedOrder.createdAt:@"--"];
    }
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

-(EFSection *)loadSection{
    EFSection * section = [EFNibHelper loadNibNamed:@"STOProductOrderDetailSection" ofClass:[STOProductOrderDetailSection class]];
    self.fillParentEnabled = YES;
    return section;
}



@end
