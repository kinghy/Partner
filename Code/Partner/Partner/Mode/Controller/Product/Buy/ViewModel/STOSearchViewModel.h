//
//  STOSearchViewModel.h
//  Partner
//
//  Created by  rjt on 16/1/14.
//  Copyright © 2016年 Kinghy. All rights reserved.
//

#import "EFBaseViewModel.h"

@interface STOSearchViewModel : EFBaseViewModel
@property (nonatomic,strong) NSString* searchText;
@property (nonatomic,strong) RACCommand* cancelCmd;
@property (nonatomic,strong) RACSequence* searchStocks;

-(void)addMyStock:(NSInteger)index;
@end
