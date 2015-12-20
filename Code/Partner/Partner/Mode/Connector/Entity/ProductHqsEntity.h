//
//  ProductHqsEntity.h
//  Partner
//
//  Created by  rjt on 15/11/12.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFEntity.h"

@interface ProductHqsEntity : EFEntity
@property (nonatomic,strong) NSMutableArray *records;
@end

@interface ProductHqsRecordsEntity : EFEntity

@property (nonatomic,copy) NSString *New;
@property (nonatomic,copy) NSString *YClose;
@property (nonatomic,copy) NSString *stockname;
@property (nonatomic,copy) NSString *Buy1;
@property (nonatomic,copy) NSString *stockcode;
@property (nonatomic,copy) NSString *Sell1;
@property (nonatomic,copy) NSString *NeedAnimation;//自选股页执行变色动画

@end