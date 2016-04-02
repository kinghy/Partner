//
//  PersonalSection.m
//  Partner
//
//  Created by kinghy on 15/12/20.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "PersonalSection.h"
#import "UIImage+ImageEffects.h"

@implementation PersonalHeaderSection
-(void)setHeader:(UIImage *)img{
    self.clipsToBounds = YES;
    self.logoImg.image = img;
    self.logoImg.layer.cornerRadius = self.logoImg.frame.size.width/2;
    self.logoImg.layer.borderColor = kColorLogoBorder.CGColor;
    self.logoImg.layer.borderWidth = 1.f;
    self.logoImg.clipsToBounds = YES;
//    self.backgroundImg.image = [img blurImage];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


