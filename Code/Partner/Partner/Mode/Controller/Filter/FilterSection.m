//
//  FilterSection.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "FilterSection.h"

@implementation FilterSection

-(void)awakeFromNib{
    [self.confirmBtn.layer setCornerRadius:5.f];
    self.confirmBtn.selectedBackgroundColor = kBtnColorSelected;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation FilterMarketSection 

@end

@implementation FilterButton
-(void)awakeFromNib{
    
}


@end