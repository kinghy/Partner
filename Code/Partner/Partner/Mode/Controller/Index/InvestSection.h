//
//  InvestSection.h
//  Invest
//
//  Created by kinghy on 15/10/1.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface InvestSection : EFSection
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *info;

@property (weak, nonatomic) IBOutlet UIImageView *logo;

@end

@interface InvestHeadSection : EFSection


@end