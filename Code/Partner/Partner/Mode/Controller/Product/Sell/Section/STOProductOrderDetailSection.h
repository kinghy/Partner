//
//  STOProductOrderDetailSection.h
//  Partner
//
//  Created by  rjt on 15/11/26.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface STOProductOrderDetailSection : EFSection
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractDetail;
@end
