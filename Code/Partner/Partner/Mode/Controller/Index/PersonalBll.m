//
//  PersonalBll.m
//  Partner
//
//  Created by kinghy on 15/12/20.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "PersonalBll.h"
#import "PersonalSection.h"

@implementation PersonalBll
-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor *adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"PersonalSection"] delegate:self];
    [adpator addEntity:[EFEntity entity] withSection:[PersonalHeaderSection class]];
    adpator.scrollEnabled = YES;
    return adpator;
}

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isKindOfClass:[PersonalHeaderSection class]]) {
        PersonalHeaderSection *s = (PersonalHeaderSection*)section;
        s.clipsToBounds = YES;
        s.logoImg.image = [UIImage imageNamed:@"cong.jpg"];
        s.logoImg.layer.cornerRadius = s.logoImg.frame.size.width/2;
        s.logoImg.layer.borderColor = [UIColor whiteColor].CGColor;
        s.logoImg.layer.borderWidth = 1.f;
        s.logoImg.clipsToBounds = YES;
        CIContext *context = [CIContext contextWithOptions:nil];
        UIImage* img = [UIImage imageNamed:@"cong.jpg"];
        CIImage *image = [CIImage imageWithCGImage:img.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setValue:image forKey:kCIInputImageKey];
        [filter setValue:@2.0f forKey: @"inputRadius"];
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
        UIImage * blurImage = [UIImage imageWithCGImage:outImage];
        s.backgroundImg.image = blurImage;
    }
}
@end
