//
//  PersonalSection.m
//  Partner
//
//  Created by kinghy on 15/12/20.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "PersonalSection.h"

@implementation PersonalHeaderSection
-(void)setHeader:(UIImage *)img{
    self.clipsToBounds = YES;
    self.logoImg.image = img;
    self.logoImg.layer.cornerRadius = self.logoImg.frame.size.width/2;
    self.logoImg.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoImg.layer.borderWidth = 1.f;
    self.logoImg.clipsToBounds = YES;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:img.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:image forKey:kCIInputImageKey];
    [filter setValue:@2.0f forKey: @"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
    self.backgroundImg.image = blurImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation PersonalMiddleSection

@end
