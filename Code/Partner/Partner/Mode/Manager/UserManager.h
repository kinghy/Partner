//
//  UserManager.h
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseManager.h"
@class AuthenticateEntity;

@interface UserManager : EFBaseManager
single_interface(UserManager)

@property (strong,nonatomic) AuthenticateEntity* myEntity;

-(NSString*)getUserID;

-(void)loginWithName:(NSString*)name andPwd:(NSString*)password andBlock:(EFManagerRetBlock)returnBlock;
@end
