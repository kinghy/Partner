//
//  STOSearchViewController.h
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/9.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "EFTableView.h"

@interface STOSearchViewController : EFSimpleViewController

@property (assign,nonatomic)BOOL canDismiss;

@property (weak, nonatomic) IBOutlet UITextField *search;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end
