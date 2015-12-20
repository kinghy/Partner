//
//  ProductOrdersEntity.h
//  Partner
//
//  Created by  rjt on 15/11/25.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "AppEntity.h"

@interface ProductOrdersEntity : AppEntity
@property (nonatomic,strong) NSMutableArray* records;
@end

@interface ProductOrdersRecordsEntity : AppEntity
@property (nonatomic,strong) NSString* ID;
@property (nonatomic,strong) NSString* stockNo;
@property (nonatomic,strong) NSString* amount;
@property (nonatomic,strong) NSString* price;
@property (nonatomic,strong) NSString* status;
@property (nonatomic,strong) NSString* owner;
@property (nonatomic,strong) NSString* contractId;
@property (nonatomic,strong) NSString* type;
@property (nonatomic,strong) NSString* createdAt;
@property (nonatomic,strong) NSString* updatedAt;
@property (nonatomic,strong) NSString* contractNo;

@end
