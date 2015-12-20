//
//  FilterSection.h
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface FilterSection : EFSection
@property (weak, nonatomic) IBOutlet EFButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UILabel *ernest;
@property (weak, nonatomic) IBOutlet UILabel *bailRate;
@property (weak, nonatomic) IBOutlet UILabel *investLimit;
@property (weak, nonatomic) IBOutlet UILabel *investMoney;
@property (weak, nonatomic) IBOutlet UIButton *investMoneyBtn;
@property (weak, nonatomic) IBOutlet UIButton *investLimitBtn;
@property (weak, nonatomic) IBOutlet UIButton *bailRateBtn;
@property (weak, nonatomic) IBOutlet UIButton *ernestBtn;
@end
