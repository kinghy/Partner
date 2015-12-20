//
//  EFTableView.m
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "EFTableView.h"

@implementation EFTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(void)layoutSubviews{
    if ([self.efDelegate respondsToSelector:@selector(willLayoutSubviewsInTableView:)]) {
        [self.efDelegate willLayoutSubviewsInTableView:self];
    }
    [super layoutSubviews];
}

@end
