//
//  STOProductViewController.m
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBll.h"
#import "STOProductFreeStyleBll.h"
#import "STOProductViewController.h"
#import "STOProductSellBll.h"
#import "STOSearchViewController.h"
#import "UIBarButtonItem+YL.h"
#import "STOSearchViewModel.h"

@interface STOProductViewController ()


@property (nonatomic,strong) STOProductFreeStyleBll* buyBll;
//@property (nonatomic,strong) STOProductSellBll* sellBll;
@end

@implementation STOProductViewController

- (void)viewDidLoad {
//    [self createNavTitle];
    [super viewDidLoad];
    self.title = @"沪深A股";
    self.statusBarStyle = UIStatusBarStyleDefault;
    [self setRightNavBarWithImage:@"mysearch" heighLight:@"mysearch" action:@selector(gotoSearch)];

    
    // Do any additional setup after loading the view from its nib.
//    [self addSwither:self.buyBtn forBll:self.buyBll];
//    [self addSwither:self.sellBtn forBll:self.sellBll];
//    [self switchClicked:self.buyBtn];
}

-(void)initBll{
    self.buyBll = [STOProductFreeStyleBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.pBuyTable}];
    [self.buyBll show];
//    self.sellBll = [STOProductSellBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.pSellTable}];
//    [self.sellBll hide];
}

-(void)gotoSearch{
    STOSearchViewController *controller = [STOSearchViewController controllerWithModel:[STOSearchViewModel viewModel] nibName:@"STOSearchViewController" bundle:nil];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


-(void)viewController:(EFBaseViewController *)controller dismissedWithObject:(id)obj{
    if (obj) {
        [self.buyBll goMarket:obj];
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

@end
