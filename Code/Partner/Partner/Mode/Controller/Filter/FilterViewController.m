//
//  FilterViewController.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterBll.h"
#import "StockFilterBll.h"
#import "AuFilterBll.h"
#import "AgFilterBll.h"
#import "CreateFilterBll.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *stockBtn;
@property (weak, nonatomic) IBOutlet UIButton *auBtn;
@property (weak, nonatomic) IBOutlet UIButton *agBtn;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet EFTableView *stockTable;
@property (weak, nonatomic) IBOutlet EFTableView *auTable;
@property (weak, nonatomic) IBOutlet EFTableView *agTable;
@property (weak, nonatomic) IBOutlet EFTableView *createTable;

@property (strong, nonatomic) FilterBll *stockBll;
@property (strong, nonatomic) FilterBll *auBll;
@property (strong, nonatomic) FilterBll *agBll;
@property (strong, nonatomic) FilterBll *createBll;

@property (weak, nonatomic) IBOutlet UIView *switcherView;

@property (strong,nonatomic) UIImageView *selectedView;
- (IBAction)cancelClicked:(id)sender;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.title = @"筛选";
    self.selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
    [self.switcherView addSubview:self.selectedView];
    [self addSwither:self.stockBtn forBll:self.stockBll];
    [self addSwither:self.auBtn forBll:self.auBll];
    [self addSwither:self.agBtn forBll:self.agBll];
    [self addSwither:self.createBtn forBll:self.createBll];
    
    [self switchClicked:self.stockBtn];
    // Do any additional setup after loading the view from its nib.
}

-(void)swither:(UIControl *)sw andBll:(EFBll *)bll fromSwitcher:(UIControl *)oldSw andBll:(EFBll *)oldbll{
    UIButton *btn = (UIButton*)sw;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if (oldbll) {
        [UIView animateWithDuration:.2f animations:^{
            self.selectedView.frame = CGRectMake(btn.frame.origin.x+btn.frame.size.width/2-self.selectedView.frame.size.width/2, btn.frame.size.height-self.selectedView.frame.size.height, self.selectedView.frame.size.width,self.selectedView.frame.size.height);
        }];
    }else{
        self.selectedView.frame = CGRectMake(btn.frame.origin.x+btn.frame.size.width/2-self.selectedView.frame.size.width/2, btn.frame.size.height-self.selectedView.frame.size.height, self.selectedView.frame.size.width,self.selectedView.frame.size.height);
    }
    

    UIButton *oldbtn = (UIButton*)oldSw;
    [oldbtn setTitleColor:kColorSwitchUnselected forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBll{
    self.stockBll = [StockFilterBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.stockTable}];
    self.auBll= [AuFilterBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.auTable}];
    self.agBll = [AgFilterBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.agTable}];
    self.createBll = [CreateFilterBll bllWithController:self tableViewDict:@{kBllUniqueTable:self.createTable}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
