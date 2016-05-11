//
//  STOProductMarketViewController.m
//  Partner
//
//  Created by  rjt on 15/10/26.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductMarketViewController.h"
#import "STOProductMarketBll.h"

@interface STOProductMarketViewController ()
@property (strong, nonatomic) STOProductMarketBll *marketBll;
@end

@implementation STOProductMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleDefault;
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
    self.marketBll = [STOProductMarketBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.mainTable}];
}

@end
