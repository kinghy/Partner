//
//  UIView+RemoveSubviews.m
//  Partner
//
//  Created by  rjt on 15/10/27.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "UIView+RemoveSubviews.h"

@implementation UIView (RemoveSubviews)
-(void)removeAllSubviews{
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}
@end
