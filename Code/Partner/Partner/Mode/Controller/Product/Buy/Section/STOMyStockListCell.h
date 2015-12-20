//
//  STOMyStockListCell.h
//  QianFangGuJie
//
//  Created by tongshangren on 15/8/18.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STOMyStockListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *stockName;
@property (weak, nonatomic) IBOutlet UILabel *stockCode;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *change;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
