//
//  IndexViewController.m
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "IndexViewController.h"
#import "PartnerBll.h"
#import "InvestBll.h"
#import "FilterViewController.h"
#import "PersonalBll.h"

@interface IndexViewController ()<UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet EFTableView *partnerTable;
@property (weak, nonatomic) IBOutlet EFTableView *investTable;
@property (weak, nonatomic) IBOutlet EFTableView *personalTable;

@property (strong, nonatomic) PartnerBll *partnerBll;
@property (strong, nonatomic) InvestBll *investBll;
@property (strong, nonatomic) PersonalBll *personalBll;
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBarHidden = NO;
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.tabBar.delegate =self;
    self.title = @"合伙";
    [self setRightNavBarWithTitle:@"" image:[UIImage imageNamed:@"filter"] action:@selector(filterClicked:)]; 
    self.tabBar.selectedItem = self.tabBar.items[0];
    self.navigationItem.hidesBackButton = YES;
}

-(void)filterClicked:(id)Obj{
    FilterViewController *filter = [[FilterViewController alloc] init];
    [self.navigationController pushViewController:filter animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.partnerBll show];
    
}

-(void)initBll{
    
    self.partnerBll = [PartnerBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.partnerTable}];
    [self.partnerBll hide];
    self.investBll = [InvestBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.investTable}];
    [self.investBll hide];
    self.personalBll = [PersonalBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.personalTable}];
    [self.personalBll hide];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 0) {
        [self.partnerBll show];
        [self.investBll hide];
        [self.personalBll hide];
        self.title = @"合伙";
        self.navBarHidden = NO;
        [self setRightNavBarWithTitle:@"" image:[UIImage imageNamed:@"filter"] action:@selector(filterClicked:)];
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }else if(item.tag == 1){
        [self.partnerBll hide];
        [self.investBll show];
        [self.personalBll hide];
        self.title = @"投资";
        self.navBarHidden = NO;
        self.navigationItem.rightBarButtonItem = nil;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }else if(item.tag == 2){
        [self.partnerBll hide];
        [self.investBll hide];
        [self.personalBll show];
//        self.title = @"个人";
//        
//        self.navigationItem.rightBarButtonItem = nil;
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
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
