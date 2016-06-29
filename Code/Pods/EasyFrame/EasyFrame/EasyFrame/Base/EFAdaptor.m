//
//  EFAdaptor.m
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "EFAdaptor.h"
#import "EFSource.h"
#import "EFTableView.h"
#import "EFSection.h"
#import "EFSourceItem.h"
#import "EFNibHelper.h"
#import "UIView+RemoveSubviews.h"
#import "EFHLine.h"
#import "EFEmptyEntity.h"

@implementation EFAdaptor{
    CGFloat tableHieght ;
}

+(instancetype)adaptor{
    return [[self alloc] init];
}

+(instancetype)adaptorWithTableView:(EFTableView*)tableView nibArray:(NSArray*)array delegate:(id<EFAdaptorDelegate>)delegate
{
    EFAdaptor* adaptor=nil;
    @synchronized(self)
    {
        adaptor= [self adaptor];
        adaptor.delegate=delegate;
        EFSource* source= [EFSource source];
        [adaptor bindSource:source andTableView:tableView nibArray:array];
    }
    return adaptor;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _pSectionInfos = [[NSMutableArray alloc] init];
        _scrollEnabled = NO;
        _selectAutoCancel = YES;
        _fillParentEnabled = NO;
        tableHieght = 0.f;
    }
    return self;
}

-(void)setScrollEnabled:(BOOL)scrollEnabled{
    _scrollEnabled = scrollEnabled;
    self.pTableView.scrollEnabled = _scrollEnabled;
}

-(void)bindSource:(EFSource *)sources andTableView:(EFTableView *)tableView nibArray:(NSArray *)nibArray{
    /** 记录section高度 */
    for (NSString* nibName in nibArray)
    {
        NSArray* list = [EFNibHelper loadNibNamed:nibName];
        
        for (EFSection* s in list) {
            EFSectionInfo* i = [EFSectionInfo infoWithName:NSStringFromClass([s class]) andBounds:s.bounds];
            [self.pSectionInfos addObject:i];
        }
    }
    self.pSources = sources;
    self.pTableView = tableView;
    self.pTableView.scrollEnabled = _scrollEnabled;
    self.pTableView.separatorStyle = NO;
    self.pNibNameArray = nibArray;
    self.pTableView.delegate = self;
    self.pTableView.dataSource = self;
    self.pTableView.efDelegate = self;
}

-(void)fillParent{
    NSArray* items = [self.pSources allItems];
    CGFloat height = 0;
    for (EFSourceItem *item in items) {
        EFSectionInfo *info = [self findInfoByName:item.sectionName];
        if (item.sectionHeight == 0) {
            item.sectionHeight = info.bounds.size.height;
        }
        height += item.sectionHeight;
    }
    CGFloat rate = self.pTableView.frame.size.height/height;
    for (EFSourceItem *item in items) {
        item.sectionHeight = item.sectionHeight*rate;//不能通过sectionHeight设置高度
    }
}

-(EFSectionInfo*)findInfoByName:(NSString*)name{
    EFSectionInfo* retInfo = nil;
    for (EFSectionInfo* info in self.pSectionInfos) {
        if ([info.name isEqualToString:name]) {
            retInfo = info;
            break;
        }
    }
    return retInfo;
}

-(void)notifyChanged{
    if(self.pTableView){
        [self.pTableView reloadData];
    }
}

-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass andGroup:(NSString *)group{
    [self.pSources addEntity:entity withSection:sectionClass andGroup:group];
}

-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass{
    [self.pSources addEntity:entity withSection:sectionClass];
}
-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass andHeight:(CGFloat)height{
    [self.pSources addEntity:entity withSection:sectionClass andHeight:height];
}

-(void)addEntity:(EFEntity *)entity withSection:(Class)sectionClass andHeight:(CGFloat)height andGroup:(NSString *)group{
    [self.pSources addEntity:entity withSection:sectionClass andHeight:height andGroup:group];
}

-(void)addSetEntity:(EFSetEntity *)entity andGroup:(NSString *)group{
    [self.pSources addEntity:entity withSection:[EFSection class] andHeight:kCellHeight andGroup:group];
}
-(void)addSetEntity:(EFSetEntity *)entity andHeight:(CGFloat)height andGroup:(NSString *)group{
    [self.pSources addEntity:entity withSection:[EFSection class] andHeight:height andGroup:group];
}

-(void)clear{
    [self.pSources clear];
}


#pragma mark - EFTableViewDelegate
-(void)willLayoutSubviewsInTableView:(EFTableView *)tableView{
    if (self.fillParentEnabled && tableView.frame.size.height != tableHieght) {
        //避免重复跳转，提高效率
        tableHieght = tableView.frame.size.height;
        [self fillParent];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.pSources groupCount];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.pSources sectionCountByGroupIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat height = kCellHeight;
    EFSourceGroupItem *item = [self.pSources groupSecionByIndex:section];
    if (item.sectionName==nil || [item.sectionName isEqualToString:NSStringFromClass([EFSection class])]) {
        return 0;
    }
    if (item.sectionHeight>0) {
        height = item.sectionHeight;
    }else{
        for (EFSectionInfo *info in self.pSectionInfos) {
            if ([info.name isEqualToString:item.sectionName]) {
                height = info.bounds.size.height;
            }
        }
    }
    return height;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    EFSourceGroupItem *item = [self.pSources groupSecionByIndex:section];
    if (item.section!=nil && [self.delegate respondsToSelector:@selector(EFAdaptor:forGroupSection:forEntity:)]) {
        [self.delegate EFAdaptor:self forGroupSection:item.section forEntity:item.entity];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EFSourceGroupItem *item = [self.pSources groupSecionByIndex:section];
    if (item.sectionName==nil || [item.sectionName isEqualToString:NSStringFromClass([EFSection class])]) {
        return nil;
    }
    EFSection *s = [EFNibHelper loadNibArray:self.pNibNameArray ofClass:NSClassFromString(item.sectionName)];
    item.section = s;
    [s sectionWillLoad];

    if ([self.delegate respondsToSelector:@selector(EFAdaptor:willDidLoadGroupSection:willDidLoadEntity:)]) {
        [self.delegate EFAdaptor:self willDidLoadGroupSection:s willDidLoadEntity:item.entity];
    }
    [s sectionDidLoad];
    return s;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = kCellHeight;
    EFSourceItem *item = [self.pSources secionByEntityIndex:indexPath.row andGroupIndex:indexPath.section];
    if (item.sectionHeight>0) {
        height = item.sectionHeight;
    }else{
        for (EFSectionInfo *info in self.pSectionInfos) {
            if ([info.name isEqualToString:item.sectionName]) {
                height = info.bounds.size.height;
            }
        }
    }
    return height;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EFSourceItem *item = [self.pSources secionByEntityIndex:indexPath.row andGroupIndex:indexPath.section];
//    item.entity.tag = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.sectionName];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier: item.sectionName];
    }
    EFSection* section = item.section;
    if(cell.contentView.subviews.count>0 &&  item.section == cell.contentView.subviews[0]){
        section = item.section;
//    }else if ([item.sectionName isEqualToString:@"EFSection"]) {
//        section = [[EFSection alloc] init];
    }else{
        /** 如果实现了自定义Section初始化委托，用于notifyChangeForSection 时，复用现有Section */
        if([self.delegate respondsToSelector:@selector(EFAdaptor:initSectionClass:)])
        {
            section= [self.delegate EFAdaptor:self initSectionClass:NSClassFromString(item.sectionName)];
            if(!section){
                section = [EFNibHelper loadNibArray:self.pNibNameArray ofClass:NSClassFromString(item.sectionName)];
            }
        }
        else{
            section = [EFNibHelper loadNibArray:self.pNibNameArray ofClass:NSClassFromString(item.sectionName)];
        }
        [section sectionWillLoad];
        if ([self.delegate respondsToSelector:@selector(EFAdaptor:willDidLoadSection:willDidLoadEntity:)]) {
            [self.delegate EFAdaptor:self willDidLoadSection:section willDidLoadEntity:item.entity];
        }
        if ([item.entity isKindOfClass:[EFSetEntity class]]) {
            EFSetEntity* setEntity = (EFSetEntity*)item.entity;
            cell.textLabel.text = setEntity.text;
            cell.detailTextLabel.text = setEntity.detailText;
            cell.imageView.image = setEntity.image;
            
            cell.showsReorderControl = setEntity.showsReorderControl;
            cell.shouldIndentWhileEditing = setEntity.shouldIndentWhileEditing;
            cell.accessoryType = setEntity.accessoryType;
            cell.editingAccessoryType = setEntity.editingAccessoryType;
//            cell.indentationLevel = setEntity.indentationLevel;
//            cell.indentationWidth = setEntity.indentationWidth;
            
            float indentation = 15*setEntity.indentationLevel;
            float height = item.sectionHeight==0?kCellHeight:item.sectionHeight;
            EFHLine *line = [EFHLine lineWithFrame:CGRectMake(0+indentation, height-1, tableView.frame.size.width-indentation, 1) andColor:kLineColor];
            [cell addSubview:line];
            
        }else if ([item.entity isKindOfClass:[EFEmptyEntity class]]) {
            EFEmptyEntity* setEntity = (EFEmptyEntity*)item.entity;
//            cell.indentationLevel = setEntity.indentationLevel;
//            cell.indentationWidth = setEntity.indentationWidth;
            
            cell.backgroundColor = [UIColor colorWithRed:246.f/250.f green:246.f/250.f blue:246.f/250.f alpha:1.f];
            float indentation = 15*setEntity.indentationLevel;
            
            EFHLine *line = [EFHLine lineWithFrame:CGRectMake(0+indentation, item.sectionHeight-1, tableView.frame.size.width-indentation, 1) andColor:kLineColor];
            [cell addSubview:line];
            
        }else{
            [cell.contentView removeAllSubviews];
            CGRect rect = cell.contentView.bounds;
            rect.size.height = item.sectionHeight>0?item.sectionHeight:section.frame.size.height;
            cell.contentView.bounds = rect;
            section.frame =  cell.contentView.bounds;
            [cell.contentView addSubview:section];
            [section sectionDidLoad];
        }
        item.section = section;
    }
    if ([self.delegate respondsToSelector:@selector(EFAdaptor:forSection:forEntity:)]) {
        [self.delegate EFAdaptor:self forSection:section forEntity:item.entity];
    }
    section.parentCell = cell;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate==nil)
        return;
    
    EFSourceItem* item=[self.pSources secionByEntityIndex:indexPath.row andGroupIndex:indexPath.section];
    
    //    QUSection* section=[[[tableView cellForRowAtIndexPath:indexPath] subviews] objectAtIndex:0];
    EFSection* section=[[[[tableView cellForRowAtIndexPath:indexPath] contentView] subviews] objectAtIndex:0];
    if([self.delegate respondsToSelector:@selector(EFAdaptor:selectedSection:entity:)]){
        [self.delegate EFAdaptor:self selectedSection:section entity:item.entity];
    }
    
    if (_selectAutoCancel) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end;