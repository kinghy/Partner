//
//  FilterListViewController.h
//  Partner
//
//  Created by  rjt on 15/10/14.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFBaseViewController.h"
#import "FilterListBll.h"

@interface FilterListViewController : EFBaseViewController
@property (weak, nonatomic) IBOutlet EFTableView *pTable;
@property (strong, nonatomic) FilterListBll *listBll;
@end
