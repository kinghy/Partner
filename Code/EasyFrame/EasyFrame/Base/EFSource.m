//
//  EFSource.m
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "EFSource.h"
#import "EFSourceItem.h"
#define kSourceDefaultGroup @"defaultGroup"

@implementation EFSource

-(instancetype)init{
    if (self = [super init]) {
        _groupDict = [NSMutableDictionary dictionary];
        _groups = [NSMutableArray array];
        
    }
    return self;
}

+(instancetype)source{
    return [[self alloc] init];
}

-(void)setGroupEntity:(EFEntity *)entity withSection:(Class)sectionClass andHeight:(CGFloat)height andGroupName:(NSString *)group{
    EFSourceGroupItem* item = [EFSourceGroupItem item:entity sectionName:NSStringFromClass(sectionClass)  sectionHeight:height groupName:group];
    //如果已被创建过则不在添加默认的组section
    EFSourceGroupItem* groupItem = nil;
    int index = -1;
    for(int i=0;i<self.groups.count;++i){
        EFSourceGroupItem *temp =  (EFSourceGroupItem *)self.groups[i];
        if ([temp.groupName isEqualToString:group]) {
            groupItem = temp;
            index = i;
        }
    }
    if (groupItem == nil) {
        [self.groups addObject:item];
    }else if(entity){
        if ([item.sectionName isEqualToString:groupItem.sectionName]) {
            groupItem.entity =entity;
        }else{
            [self.groups insertObject:item atIndex:index];
            [self.groups removeObject:groupItem];
        }
    }
}

-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass andGroup:(NSString *)group{
    [self addEntity:entity withSection:sectionClass andHeight:0 andGroup:group];
    
}



-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass andHeight:(CGFloat)height andGroup:(NSString *)group{
    if (entity) {
        EFSourceItem* item = [EFSourceItem item:entity sectionName:NSStringFromClass(sectionClass) sectionHeight:height];
        NSMutableArray* arr = [self.groupDict valueForKey:group];
        if (arr==nil) {
            arr = [NSMutableArray array];
            [arr addObject:item];
            [self setGroupEntity:nil withSection:[EFSection class] andHeight:0 andGroupName:group];
        }else{
            [arr addObject:item];
        }
        [self.groupDict setObject:arr forKey:group];
    }
}


-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass{
    [self addEntity:entity withSection:sectionClass andGroup:kSourceDefaultGroup];
}
-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass andHeight:(CGFloat)height{
    [self addEntity:entity withSection:sectionClass andHeight:height andGroup:kSourceDefaultGroup];
}

-(NSInteger)groupCount{
    return [self.groups count];
}

-(NSInteger)sectionCountByGroupIndex:(NSInteger)groupIndex{
    return [[self.groupDict valueForKey:((EFSourceGroupItem*)self.groups[groupIndex]).groupName] count];
}

-(NSInteger)sectionCountByGroup:(NSString *)group{
    NSInteger index;
    for (index=0;index < self.groups.count ;++index) {
        if ([group isEqualToString:((EFSourceGroupItem*)self.groups[index]).groupName]) {
            break;
        }
    }
    return [self sectionCountByGroupIndex:index];
}

-(EFSourceItem*)secionByEntityIndex:(NSInteger)sectionIndex andGroupIndex:(NSInteger)groupIndex{
    NSString *gname = ((EFSourceGroupItem*)self.groups[groupIndex]).groupName;
    if (gname == nil) {
        return nil;
    }
    NSMutableArray *arr = [self.groupDict objectForKey:gname];
    return  [arr objectAtIndex:sectionIndex];
}

-(EFSourceGroupItem*)groupSecionByIndex:(NSInteger)groupIndex{
    return  (EFSourceGroupItem*)self.groups[groupIndex];
}


-(void)removeSectionByClass:(Class)cls{
    for (NSString *key in [self.groupDict allKeys]) {
        NSMutableArray *array = [NSMutableArray array];
        for (EFSourceItem *item in self.groupDict[key]) {
            if (![item.section isKindOfClass:cls]) {
                [array addObject:item];
            }
        }
        [self.groupDict setObject:array forKey:key];
    }
}

-(NSArray *)allItems{
    NSMutableArray *array = [NSMutableArray array];
    for (EFSourceGroupItem* group in self.groups) {
        NSArray * items = [self.groupDict objectForKey:group.groupName];
        [array addObjectsFromArray:items];
    }
    return array;
}


-(void)clear{

    for (id group in self.groups) {
        [self.groupDict[group] removeAllObjects];
    }
    [self.groups removeAllObjects];
    [self.groupDict removeAllObjects];
}

-(void)dealloc{
    show_dealloc_info(self);
}

@end;
