//
//  STOProductBuyOrderSection.h
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface STOProductBuyOrderSection : EFSection
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *minMoneyLabel;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIButton *contractBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *contractNoLabel;


@end

@interface STOProductContractsSection : EFSection

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet EFTableView *contractTable;
@end

@interface STOProductContractsHeaderSection : EFSection

@end

@interface STOProductContractsListSection : EFSection
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UILabel *limitLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@interface STOProductBuyOrderPriceSection : EFSection

@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *rhythmLab;
@property (weak, nonatomic) IBOutlet UILabel *percentLab;

@property (weak, nonatomic) IBOutlet UILabel *openLab;
@property (weak, nonatomic) IBOutlet UILabel *closeLab;
@property (weak, nonatomic) IBOutlet UILabel *highestLab;
@property (weak, nonatomic) IBOutlet UILabel *lowestLab;

@end

@interface STOProductBuyOrderHandicapSection : EFSection

@property (weak, nonatomic) IBOutlet UILabel *sell1Lab;
@property (weak, nonatomic) IBOutlet UILabel *sell2Lab;
@property (weak, nonatomic) IBOutlet UILabel *sell3Lab;
@property (weak, nonatomic) IBOutlet UILabel *sell4Lab;
@property (weak, nonatomic) IBOutlet UILabel *sell5Lab;

@property (weak, nonatomic) IBOutlet UILabel *buy1Lab;
@property (weak, nonatomic) IBOutlet UILabel *buy2Lab;
@property (weak, nonatomic) IBOutlet UILabel *buy3Lab;
@property (weak, nonatomic) IBOutlet UILabel *buy4Lab;
@property (weak, nonatomic) IBOutlet UILabel *buy5Lab;

@property (weak, nonatomic) IBOutlet UILabel *sell1VolLab;
@property (weak, nonatomic) IBOutlet UILabel *sell2VolLab;
@property (weak, nonatomic) IBOutlet UILabel *sell3VolLab;
@property (weak, nonatomic) IBOutlet UILabel *sell4VolLab;
@property (weak, nonatomic) IBOutlet UILabel *sell5VolLab;

@property (weak, nonatomic) IBOutlet UILabel *buy1VolLab;
@property (weak, nonatomic) IBOutlet UILabel *buy2VolLab;
@property (weak, nonatomic) IBOutlet UILabel *buy3VolLab;
@property (weak, nonatomic) IBOutlet UILabel *buy4VolLab;
@property (weak, nonatomic) IBOutlet UILabel *buy5VolLab;

@end