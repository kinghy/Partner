//
//  PartnerViewModel.h
//  Partner
//
//  Created by  rjt on 16/1/12.
//  Copyright © 2016年 Kinghy. All rights reserved.
//

#import "EFBaseViewModel.h"
#import <ReactiveCocoa.h>
@interface PartnerViewModel : EFBaseViewModel
@property (nonatomic,strong) RACSequence* seqPartner;

-(void)getPartner;
@end
