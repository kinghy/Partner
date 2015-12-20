//
//  ContractManager.h
//  Partner
//
//  Created by  rjt on 15/11/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseManager.h"
#import "ContractsEntity.h"
#import "DocumentEntity.h"

@interface ContractManager : EFBaseManager
single_interface(ContractManager)

@property (nonatomic,strong) ContractsRecordsEntity *selectedContract;
@property (nonatomic,strong) DocumentEntity *createdDocument;

-(void)filterContract:(EFManagerRetBlock)returnBlock;
-(void)createDocument:(EFManagerRetBlock)returnBlock;
-(void)signDocument:(EFManagerRetBlock)returnBlock;
@end
