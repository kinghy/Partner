//
//  ContractSection.h
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface ContractSection : EFSection
@property (weak, nonatomic) IBOutlet EFButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *marketName;
@property (weak, nonatomic) IBOutlet UILabel *partner;
@property (weak, nonatomic) IBOutlet UILabel *limit;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *rate;
@property (weak, nonatomic) IBOutlet UILabel *allocation;

@property (weak, nonatomic) IBOutlet UILabel *investorName;



@end

