//
//  STOProductBuyOrderBll.h
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBll.h"

@class STOProductBuyOrderSection;
@class ProductPanKouEntity;
@class STOProductContractsSection;
@class STOProductBuyOrderViewModel;

@interface STOProductBuyOrderBll : EFBll<UITableViewDataSource,UITableViewDelegate>{
    NSArray* contracts;
    STOProductContractsSection* contractSection;
}

@property (nonatomic,strong) ProductPanKouEntity* pankouEntity;

@property (weak,nonatomic)   STOProductBuyOrderSection* mySection;


@property (nonatomic,strong) STOProductBuyOrderViewModel *viewModel;

@end
