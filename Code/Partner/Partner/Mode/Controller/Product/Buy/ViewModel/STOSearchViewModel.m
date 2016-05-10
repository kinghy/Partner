//
//  STOSearchViewModel.m
//  Partner
//
//  Created by  rjt on 16/1/14.
//  Copyright © 2016年 Kinghy. All rights reserved.
//

#import "STOSearchViewModel.h"
#import "STODBManager.h"

@implementation STOSearchViewModel
-(void)viewModelDidLoad{
    @weakify(self)
    [[RACObserve(self, searchText) distinctUntilChanged]
      subscribeNext:^(NSString *value) {
        @strongify(self)
        //2.空格排除
        NSRange str =[value rangeOfString:@" "];
        if(str.location!=NSIntegerMax) {
            self.searchText = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
            return ;
        }
        [self getSearchContentWithText:self.searchText];
    }];

    self.cancelCmd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            self.searchText = @"";
            return nil;
        }];
    }];
    
}

-(void)getSearchContentWithText:(NSString*)searchText{
    if(searchText && ![searchText isEqualToString:@""]){
        STODBManager* dbManager = [STODBManager shareSTODBManager];
        NSArray *stockArr = [dbManager searchStockWithMathingType:[dbManager matchingTypeWithSearchText:searchText] searchText:searchText];
        self.searchStocks = stockArr.rac_sequence;
    }else{
        self.searchStocks = [RACSequence empty];
    }
}

-(void)addMyStock:(NSInteger)index{
    StockEntity* entity = [[self.searchStocks  array] objectAtIndex:index];
    StockEntity* e = [[STODBManager shareSTODBManager] accurateSearchWithStockCode:entity.stockCode];
    //检测是否已添加
    if (![e.choosed boolValue]) {
        NSString *result=[[STODBManager shareSTODBManager] addMyStockWithStockCode:entity.stockCode];
        if (![result isEqual:@""]) {
            UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertview show];
        }else{
            [self getSearchContentWithText:self.searchText];
        }
    }else{
        [[STODBManager shareSTODBManager] deleteMyStockWithStockCode:entity.stockCode];
        [self getSearchContentWithText:self.searchText];
    }
}

@end
