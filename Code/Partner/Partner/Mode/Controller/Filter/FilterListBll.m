//
//  FilterListBll.m
//  Partner
//
//  Created by  rjt on 15/10/14.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "FilterListBll.h"
#import "FilterListSection.h"

@implementation FilterListBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adaptor = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"FilterListSection"] delegate:self];
    [adaptor addEntity:[EFEntity entity] withSection:[FilterListSection class]];
    [adaptor addEntity:[EFEntity entity] withSection:[FilterInputSection class]];
    return adaptor;
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[FilterListSection class]]) {
        FilterListSection *s = (FilterListSection*)section;
        s.label.text = @"全部";
        s.label.textColor = kFilterChosedColor ;
        
    }
}
@end
