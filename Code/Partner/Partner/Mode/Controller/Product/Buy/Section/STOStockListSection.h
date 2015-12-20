//
//  STOStockListSection.h
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/9.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "EFSection.h"

@interface STOStockListSection : EFSection

@property (weak, nonatomic) IBOutlet UILabel *stockCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLab;
@property (weak, nonatomic) IBOutlet UILabel *stockAb;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
