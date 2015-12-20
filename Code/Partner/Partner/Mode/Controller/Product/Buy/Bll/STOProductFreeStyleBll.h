//
//  STOProductFreeStyleBll.h
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBll.h"

@class STOProductFreeStyleSection;
@class STOProductFreeStyleViewModel;
@interface STOProductFreeStyleBll : EFBll<UITableViewDataSource,UITableViewDelegate>{
    BOOL isSearch;
}

@property (nonatomic,strong) STOProductManager *manager;
@property (nonatomic,strong) STOProductFreeStyleSection *mySection;

@property (nonatomic,strong) STOProductFreeStyleViewModel *viewModel;

@end
