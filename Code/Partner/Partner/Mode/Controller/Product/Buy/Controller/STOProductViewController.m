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

@interface STOProductViewController ()
@property (nonatomic,strong) UIButton* buyBtn;
@property (nonatomic,strong) UIButton* sellBtn;

@property (nonatomic,strong) STOProductFreeStyleBll* buyBll;
@property (nonatomic,strong) STOProductSellBll* sellBll;
@end

@implementation STOProductViewController

- (void)viewDidLoad {
    [self createNavTitle];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    [self addSwither:self.buyBtn forBll:self.buyBll];
    [self addSwither:self.sellBtn forBll:self.sellBll];
    [self switchClicked:self.buyBtn];
}

-(void)initBll{
    self.buyBll = [STOProductFreeStyleBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.pBuyTable}];
    [self.buyBll show];
    self.sellBll = [STOProductSellBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.pSellTable}];
    [self.sellBll hide];
}

-(void)swither:(UIControl *)sw andBll:(EFBll *)bll fromSwitcher:(UIControl *)oldSw andBll:(EFBll *)oldbll{
    if(sw!=oldSw){
        UIButton *btn = (UIButton*)sw;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:kColorNavBarSwitchButton];
        
        
        UIButton *oldbtn = (UIButton*)oldSw;
        [oldbtn setTitleColor:kColorNavBarSwitchButton forState:UIControlStateNormal];
        [oldbtn setBackgroundColor:kColorNavBar];
    }
}


//创建导航按钮
-(void)createNavTitle{
    UIView *buttonview = [[UIView alloc]init];
    [buttonview setFrame:CGRectMake(0, 0, 79*2, 24)];
    [buttonview setBackgroundColor:[UIColor redColor]];
    [buttonview.layer setCornerRadius:4.f];
    buttonview.clipsToBounds = YES;
    [buttonview.layer  setBorderWidth:0.5]; //边框宽度
    [buttonview.layer setBorderColor:kColorNavBarSwitchButton.CGColor];//边框颜色
    
    
    self.buyBtn = [[UIButton alloc]init];
    self.sellBtn = [[UIButton alloc]init];
    
    [self.buyBtn setTitle:@"买入" forState:UIControlStateNormal];
    [self.sellBtn setTitle:@"卖出" forState:UIControlStateNormal];
    
    self.buyBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
    self.sellBtn.titleLabel.font = [UIFont systemFontOfSize: 15];
    
    [self.buyBtn.layer  setBorderWidth:0.25]; //边框宽度
    [self.sellBtn.layer  setBorderWidth:0.25]; //边框宽度
    
    [self.buyBtn.layer setBorderColor:kColorNavBarSwitchButton.CGColor];//边框颜色
    [self.sellBtn.layer setBorderColor:kColorNavBarSwitchButton.CGColor];//边框颜色
    
    [self.buyBtn setFrame:CGRectMake(-1, -1, 80, 26)];
    [self.sellBtn setFrame:CGRectMake(79, -1, 80, 26)];
    
    [buttonview addSubview:self.buyBtn];
    [buttonview addSubview:self.sellBtn];
    
    self.buyBtn.tag =100;
    self.sellBtn.tag =101;
    
    [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sellBtn setTitleColor:kColorNavBarSwitchButton forState:UIControlStateNormal];
    
    [self.buyBtn setBackgroundColor:kColorNavBarSwitchButton];
    [self.sellBtn setBackgroundColor:kColorNavBar];
    
//    self.titleView = buttonview;
    self.navigationItem.titleView = buttonview;
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
