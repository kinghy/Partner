//
//  STOProductSellSection.h
//  Partner
//
//  Created by  rjt on 15/11/13.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface STOProductSellListSection : EFSection
@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UILabel *stockCode;
@property (weak, nonatomic) IBOutlet UILabel *cost;
@property (weak, nonatomic) IBOutlet UILabel *stockCount;
@property (weak, nonatomic) IBOutlet UILabel *profit;

@property (weak, nonatomic) IBOutlet UILabel *profitRate;
@end

@interface STOProductSellSection : EFSection
@property (weak, nonatomic) IBOutlet UIView *head;
@property (weak, nonatomic) IBOutlet UITableView *pTabel;
@property (weak, nonatomic) IBOutlet UIButton *retractBtn;
@property (weak, nonatomic) IBOutlet UIButton *detalBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *profit;

@end

