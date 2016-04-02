//
//  PartnerSection.h
//  Partner
//
//  Created by kinghy on 15/10/1.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"


@interface PartnerHeadSection : EFSection


@end

@interface PartnerListSection : EFSection
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *investLimit;
@property (weak, nonatomic) IBOutlet UILabel *investMoney;
@property (weak, nonatomic) IBOutlet UILabel *bailRate;
@property (weak, nonatomic) IBOutlet UILabel *earnest;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@end