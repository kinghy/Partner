//
//  PersonalBll.m
//  Partner
//
//  Created by kinghy on 15/12/20.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "PersonalBll.h"
#import "PersonalSection.h"
#import "EFEmptyEntity.h"

@implementation PersonalBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"PersonalSection"] delegate:self];
    [adpator addEntity:[EFEntity entity] withSection:[PersonalHeaderSection class]];
    [adpator addEntity:[EFEntity entity] withSection:[PersonalMiddleSection class]];
    [adpator addEntity:[EFEmptyEntity entity] withSection:[PersonalMiddleSection class] andHeight:10.f];
    EFSetEntity *entity = [EFSetEntity entity];
    entity.text = @"我的财报";
    entity.image = [UIImage imageNamed:@"report_setting"];
    entity.indentationLevel = 0;
    entity.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [adpator addEntity:entity withSection:[EFSection class]];
    entity = [EFSetEntity entity];
    entity.text = @"投资分析";
    entity.image = [UIImage imageNamed:@"analysis_setting"];
    entity.indentationLevel = 0;
    entity.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [adpator addEntity:entity withSection:[EFSection class]];
    entity = [EFSetEntity entity];
    entity.text = @"客服中心";
    entity.image = [UIImage imageNamed:@"services_setting"];
    entity.indentationLevel = 0;
    entity.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [adpator addEntity:entity withSection:[EFSection class]];
    entity = [EFSetEntity entity];
    entity.text = @"关于";
    entity.image = [UIImage imageNamed:@"about_setting"];
    entity.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    entity.indentationLevel = 0;
    [adpator addEntity:entity withSection:[EFSection class]];
    adpator.scrollEnabled = YES;
    return adpator;
}

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[PersonalHeaderSection class]]) {
        PersonalHeaderSection *s = (PersonalHeaderSection*)section;
        [s setHeader:[UIImage imageNamed:@"cong.jpg"]];
    }
}
@end
