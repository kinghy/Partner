//
//  STOProductMarketBll.h
//  Partner
//
//  Created by  rjt on 15/10/26.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBll.h"

@class STOProductMarketSection;
@class ProductPanKouEntity;
@class HandicapView;

@interface STOProductMarketBll : EFBll
@property (nonatomic,strong) ProductPanKouEntity* pankouEntity;
@property (weak,nonatomic)   STOProductMarketSection* mySection;
@property (nonatomic,strong) STOProductManager *manager;
@property(strong,nonatomic)HandicapView *handicapView;

-(void)refreshHqData;//刷新行情
//-(void)initTimer;//初始化计时器
-(void)getHqData;//获取行情
-(void)clickBuy:(NSString *)direction; //点买
@end
