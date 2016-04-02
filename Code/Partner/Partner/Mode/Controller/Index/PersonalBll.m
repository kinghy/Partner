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
    EFSetEntity *entity = [EFSetEntity entity];
    entity.text = @"投资日历";
    entity.image = [UIImage imageNamed:@"calendar_setting"];
    entity.indentationLevel = 0;
    entity.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [adpator addEntity:entity withSection:[EFSection class]];
    entity = [EFSetEntity entity];
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
    entity.text = @"风险承受能力";
    entity.image = [UIImage imageNamed:@"risk_setting"];
    entity.indentationLevel = 0;
    entity.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
