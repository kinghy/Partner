//
//  EFSourceItem.h
//  EasyFrame
//
//  Created by  rjt on 15/9/25.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EFSection.h"

@interface EFSourceItem : NSObject
+(instancetype)item:(EFEntity*)entity sectionName:(NSString*)section sectionHeight:(CGFloat)height;

-(instancetype)initWithEntity:(EFEntity*)entity sectionName:(NSString*)section  sectionHeight:(CGFloat)height;

@property (strong,nonatomic) EFEntity* entity;
@property (strong,nonatomic) NSString* sectionName;
@property CGFloat sectionHeight;
@property (weak,nonatomic) EFSection* section;

@end

@interface EFSourceGroupItem : EFSourceItem
+(instancetype)item:(EFEntity*)entity sectionName:(NSString*)section sectionHeight:(CGFloat)height groupName:(NSString*)groupName;

-(instancetype)initWithEntity:(EFEntity*)entity sectionName:(NSString*)section  sectionHeight:(CGFloat)height groupName:(NSString*)groupName;

@property (strong,nonatomic) NSString* groupName;

@end