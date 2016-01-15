//
//  STOProductFreeStyleSection.h
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface STOProductFreeStyleSection : EFSection
@property (weak, nonatomic) IBOutlet UIButton *shBtn;
@property (weak, nonatomic) IBOutlet UILabel *shLabel;
@property (weak, nonatomic) IBOutlet UILabel *shMinus;
@property (weak, nonatomic) IBOutlet UIButton *szBtn;
@property (weak, nonatomic) IBOutlet UILabel *szLabel;
@property (weak, nonatomic) IBOutlet UILabel *szMinus;
@property (weak, nonatomic) IBOutlet UIImageView *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITableView *myStockTable;
@property (weak, nonatomic) IBOutlet UIView *addMyStoctView;
@property (weak, nonatomic) IBOutlet UIButton *addMyStockBtn;
@end
