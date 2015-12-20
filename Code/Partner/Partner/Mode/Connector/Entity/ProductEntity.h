//
//  ProductEntity.h
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AppEntity.h"

@interface ProductEntity : AppEntity
@property (strong, nonatomic)  NSString *title;
@property (strong, nonatomic)  NSString *investLimit;
@property (strong, nonatomic)  NSString *investMoney;
@property (strong, nonatomic)  NSString *bailRate;
@property (strong, nonatomic)  NSString *earnest;
@property (strong, nonatomic)  NSString *logo;
@end
