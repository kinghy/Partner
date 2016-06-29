//
//  EFBaseViewModel.m
//  EasyFrame
//
//  Created by  rjt on 15/12/4.
//  Copyright © 2015年 JYZD. All rights reserved.
//

#import "EFBaseViewModel.h"

@implementation EFBaseViewModel

+(instancetype)viewModel{
    return [[self alloc] init];
}

-(instancetype)init{
    if (self = [super init]) {
        [self viewModelDidLoad];
    }
    return self;
}

-(void)viewModelDidLoad{

}

-(void)dealloc{
    show_dealloc_info(self);
}
@end
