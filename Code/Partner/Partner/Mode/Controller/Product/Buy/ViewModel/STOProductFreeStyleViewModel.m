//
//  STOProductFreeStyleViewModel.m
//  Partner
//
//  Created by  rjt on 15/12/9.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductFreeStyleViewModel.h"
#import "ProductHqsEntity.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation STOProductFreeStyleViewModel
-(void)viewModelDidLoad{
    [super viewModelDidLoad];
    self.manager = [STOProductManager shareSTOProductManager];
}

-(void)refreshHq{
    @weakify(self);
    NSString *code = @"sh.999999;399001;";
    [self.manager refreshHQWithCode:code Block:^(EFEntity *entity, NSError *error) {
        @strongify(self);
        ProductHqsEntity *hqEntity = (ProductHqsEntity *)entity;
        if (hqEntity==nil) {
            return;
        }
        for (ProductHqsRecordsEntity *e in hqEntity.records) {
            if ([[e.stockcode lowercaseString] isEqualToString:@"sh.999999"]) {
                self.indexYSH = [NSNumber numberWithFloat:[e.YClose floatValue]];
                self.indexSH =  [NSNumber numberWithFloat:[e.New floatValue]];
            }else if ([[e.stockcode lowercaseString] isEqualToString:@"399001"]){
                self.indexYSZ = [NSNumber numberWithFloat:[e.YClose floatValue]];
                self.indexSZ =  [NSNumber numberWithFloat:[e.New floatValue]];
            }
        }
    }];
}

-(void)refreshMyStock{
    @weakify(self);
    NSString *code = @"600685,002163,00425";
    [self.manager refreshHQWithCode:code Block:^(EFEntity *entity, NSError *error) {
        @strongify(self);
        ProductHqsEntity *hqEntity = (ProductHqsEntity *)entity;
        if (hqEntity==nil) {
            return;
        }
    }];
}
@end
