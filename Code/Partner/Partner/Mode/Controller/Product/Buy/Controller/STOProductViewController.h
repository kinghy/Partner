//
//  STOProductViewController.h
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseViewController.h"

@interface STOProductViewController : EFBaseViewController
@property (weak, nonatomic) IBOutlet EFTableView *pBuyTable;
@property (weak, nonatomic) IBOutlet EFTableView *pSellTable;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UIButton *sellBtn;

@end
