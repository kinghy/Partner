//
//  STOProductSellOrderBll.h
//  Partner
//
//  Created by  rjt on 15/11/26.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBll.h"

@class ProductPanKouEntity;
@class STOProductSellOrderSection;

@interface STOProductSellOrderBll : EFBll
@property (nonatomic,strong) ProductPanKouEntity* pankouEntity;
@property (nonatomic,strong) STOProductManager *manager;
@property (nonatomic,strong) STOProductSellOrderSection *mySection;
@end
