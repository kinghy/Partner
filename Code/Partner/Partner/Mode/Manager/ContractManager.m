//
//  ContractManager.m
//  Partner
//
//  Created by  rjt on 15/11/4.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ContractManager.h"
#import "ContractsParam.h"
#import "DocumentParam.h"
#import "DocumentSignParam.h"

@implementation ContractManager
single_implementation(ContractManager)
-(void)filterContract:(EFManagerRetBlock)returnBlock{
    ContractsParam *param = [ContractsParam param];
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
     }];
}

-(void)setSelectedContract:(ContractsRecordsEntity *)selectedContract{
    _createdDocument = nil;
    _selectedContract = selectedContract;
}

-(void)createDocument:(EFManagerRetBlock)returnBlock{
    DocumentParam *param = [DocumentParam param];
    param.contractId = self.selectedContract.ID;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if ([entity isKindOfClass:[DocumentEntity class]]) {
             _createdDocument = (DocumentEntity*)entity;
         }
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
     }];
}

-(void)signDocument:(EFManagerRetBlock)returnBlock{
    DocumentSignParam *param = [DocumentSignParam param];
    param.contractId = self.selectedContract.ID;
    param.documentId = self.createdDocument.ID;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
     }];
}

@end
