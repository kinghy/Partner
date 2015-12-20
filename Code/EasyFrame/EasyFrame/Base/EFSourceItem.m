//
//  EFSourceItem.m
//  EasyFrame
//
//  Created by  rjt on 15/9/25.
//  Copyright © 2015年 交易支点. All rights reserved.
//


#import "EFSourceItem.h"

@implementation EFSourceItem

+(instancetype)item:(EFEntity *)entity sectionName:(NSString *)section sectionHeight:(CGFloat)height{
    return [[self alloc] initWithEntity:entity sectionName:section sectionHeight:height];
}

-(instancetype)initWithEntity:(EFEntity *)entity sectionName:(NSString *)section sectionHeight:(CGFloat)height{
    if (self=[super init]) {
        _entity = entity;
        _sectionName = section;
        _sectionHeight = height;
    }
    return self;
}

@end

@implementation EFSourceGroupItem

+(instancetype)item:(EFEntity *)entity sectionName:(NSString *)section sectionHeight:(CGFloat)height groupName:(NSString *)groupName{
    return [[self alloc] initWithEntity:entity sectionName:section sectionHeight:height groupName:groupName];
}

-(instancetype)initWithEntity:(EFEntity *)entity sectionName:(NSString *)section sectionHeight:(CGFloat)height groupName:(NSString *)groupName{
    if (self=[super initWithEntity:entity sectionName:section sectionHeight:height]) {
        _groupName = groupName;
    }
    return self;
}

@end