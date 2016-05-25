//
//  EFSection.m
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "EFSection.h"

@implementation EFSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)sectionDidLoad{

}

-(void)sectionWillLoad{

}

@end


@implementation EFSectionInfo
+(instancetype)infoWithName:(NSString *)sectionName andBounds:(CGRect)bounds{
    EFSectionInfo *info = [[self alloc] init];
    info.name = sectionName;
    info.bounds = CGRectMake(0, 0, bounds.size.width, bounds.size.height) ;
    return info;
}
@end