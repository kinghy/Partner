//
//  PersonalSection.h
//  Partner
//
//  Created by kinghy on 15/12/20.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface PersonalHeaderSection : EFSection
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
-(void)setHeader:(UIImage*)img;
@end

@interface PersonalMiddleSection : EFSection
@property (weak, nonatomic) IBOutlet UIButton *msgBtn;
@property (weak, nonatomic) IBOutlet UIButton *contractBtn;

@end



