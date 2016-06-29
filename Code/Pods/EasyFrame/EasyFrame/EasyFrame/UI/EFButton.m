//
//  EFButton.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFButton.h"

@implementation EFButton

-(void)awakeFromNib{
    [self addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(btnCanceled:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnSelected:(id)obj{
    unselectedBackgroundColor = self.backgroundColor;
    [self setBackgroundColor:self.selectedBackgroundColor];
}

-(void)btnCanceled:(id)obj{
    [self setBackgroundColor:unselectedBackgroundColor];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
