//
//  MarketEntity.h
//  Partner
//
//  Created by  rjt on 15/11/17.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AppEntity.h"

@interface MarketEntity : AppEntity
@property (nonatomic,strong) NSMutableArray* records;
@end

@interface MarketRecordsEntity : AppEntity
@property (nonatomic,strong) NSString* ID;
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* marketInfo;
@end