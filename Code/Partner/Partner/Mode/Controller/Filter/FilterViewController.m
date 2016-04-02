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

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.title = @"筛选";

    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBll{
    self.pAdaptor = [EFAdaptor adaptorWithTableView:self.pTable nibArray:@[@"FilterSection"] delegate:self];
    [self.pAdaptor addEntity:[EFEntity entity] withSection:[FilterMarketSection class]];
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
-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
