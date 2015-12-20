//
//  UserManager.m
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "UserManager.h"
#import "AuthenticateParam.h"
#import "AuthenticateEntity.h"

@implementation UserManager
single_implementation(UserManager)

-(void)loginWithName:(NSString *)name andPwd:(NSString *)password andBlock:(EFManagerRetBlock)returnBlock{
    DEFINED_WEAK_SELF
    AuthenticateParam *param = [AuthenticateParam param];
    param.username = name;
    param.password = password;
    [[EFConnector connector] run:param returnBlock:
     ^(AFHTTPRequestOperation *operation, EFEntity *entity, NSError *error) {
         AuthenticateEntity* e = (AuthenticateEntity*)entity;
         if (error == nil && e.value) {
             _self.myEntity = e;
         }
         if(returnBlock!=nil){
             returnBlock(entity,error);
         }
         
     }];
}
@end
