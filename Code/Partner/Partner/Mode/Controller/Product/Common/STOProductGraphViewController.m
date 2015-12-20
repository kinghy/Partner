//
//  STOProductGraphViewController.m
//  QianFangGuJie
//
//  Created by  rjt on 15/6/1.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import "STOProductGraphViewController.h"
#import "ProductChartEntity.h"
#import "ProductVolChartEntity.h"
#import "ProductKChartEntity.h"
#import "ChartView.h"
#import "KChartView.h"
#import "STOProductManager.h"

@interface STOProductGraphViewController ()

@end

@implementation STOProductGraphViewController

- (void)viewDidLoad {
    self.manager = [STOProductManager shareSTOProductManager];
    [super viewDidLoad];
    //STO
    _isPankou = NO;
    [self setJingdu:@"2"];
    if ([self.stockCode isEqualToString:@"399001"]) {
        [self.chartView installChartWithLine:YES histogram:YES handicap:NO];
    }else if([self.stockCode isEqualToString:@"sh.999999"]){
        [self.chartView installChartWithLine:YES histogram:YES handicap:NO];
    }else{
        [self.chartView installChartWithLine:YES histogram:YES handicap:YES];
    }
    
    [self.kchart installChart:YES stock:YES minutes:NO isNeedVol:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refreshHqChart{
    
    ProductChartEntity* ee = [[WHGlobalHelper shareGlobalHelper]get:kHqChartKey];
    NSInteger second = 1.5*60*60;//开盘的秒数
    NSArray * splittime=@[[NSDate dateWithTimeIntervalSince1970:second],
                [NSDate dateWithTimeIntervalSince1970:second+1*60*60],
                [NSDate dateWithTimeIntervalSince1970:second+2*60*60],
                [NSDate dateWithTimeIntervalSince1970:second+4.5*60*60],
                [NSDate dateWithTimeIntervalSince1970:second+5.5*60*60],
                ];
    NSArray * splitdiffer=@[@0,@(1*60),@(2*60),@(4.5*60-1.5*60),@(5.5*60-1.5*60)
                  ];
    int minutes = 240+1;//股票
    if (ee && [ee.stockcode isEqualToString: self.manager.chosedStock.stockCode]) {
        //STO
        NSRange range = [ee.markettime rangeOfString:kSTOCloseTime];
        if(range.length > 0){
            [self.chartView endPulse];
        }else{
            [self.chartView startPulse];
        }
        [self.chartView drawChartWithPrices:ee.records yClose:ee.Yclose highPrice:ee.High lowPrice:ee.Low openPrice:ee.Open time:ee.markettime animation:self.needAnimation allMinutes:minutes  spliteTime:splittime splitDiffer:splitdiffer];

        
    }
}

-(void)refreshVolChart{
    
    ProductVolChartEntity* ev = [[WHGlobalHelper shareGlobalHelper]get:kHqVolChartKey];
    NSInteger second = 1.5*60*60;//开盘的秒数
    NSArray * splittime=@[[NSDate dateWithTimeIntervalSince1970:second],
                          [NSDate dateWithTimeIntervalSince1970:second+1*60*60],
                          [NSDate dateWithTimeIntervalSince1970:second+2*60*60],
                          [NSDate dateWithTimeIntervalSince1970:second+4.5*60*60],
                          [NSDate dateWithTimeIntervalSince1970:second+5.5*60*60],
                          ];
    NSArray * splitdiffer=@[@0,@(1*60),@(2*60),@(4.5*60-1.5*60),@(5.5*60-1.5*60)
                            ];
    int minutes = 240+1;//股票
    if (ev) {
        //STO
        [self.chartView drawChartWithVols:ev.records animation:self.needAnimation stock:YES allMinutes:minutes spliteTime:splittime splitDiffer:splitdiffer];
        
    }
}


#pragma mark - 刷新K线图
-(void)refreshKchart{
    
    ProductKChartEntity* kEntity = [[WHGlobalHelper shareGlobalHelper]get:kHqKChartKey];
    if (kEntity && [kEntity.stockcode isEqualToString: self.manager.chosedStock.stockCode]) {
        self.kChartRecords = [[NSMutableArray alloc]init];
        self.KChartValidRecords = [[NSMutableArray alloc]init];
        self.MAData = [[NSMutableArray alloc]init];
        NSInteger count = [kEntity.records count];
        
        ProductKChartRecordsEntity* ordersEntity = [kEntity.records objectAtIndex:0];
        
        float kHighPrice = 0;
        float kLowPrice = 9999;
        for (int i = 0; i<count; i++) {
            ordersEntity = [kEntity.records objectAtIndex:i];
            if ([ordersEntity.High floatValue]>0) {
                if ([ordersEntity.New isEqualToString:ordersEntity.Open]) {
                    if ([ordersEntity.New floatValue]>[ordersEntity.YClose floatValue]) {
                        float price = [ordersEntity.New floatValue] - 0.01;
                        ordersEntity.Open = [NSString stringWithFormat:@"%f",price];
                    }
                    else{
                        float price = [ordersEntity.New floatValue] - 0.01;
                        ordersEntity.New = [NSString stringWithFormat:@"%f",price];
                    }
                    
                }
                [self.KChartValidRecords addObject:ordersEntity];
        
            }
        }
        for (int i = 0; i<[self.KChartValidRecords count]; i++) {
            ordersEntity = [self.KChartValidRecords objectAtIndex:i];
            if ([ordersEntity.High floatValue]<=0) {
                ordersEntity.High = ordersEntity.YClose;
            }
            if ([ordersEntity.Low floatValue]<=0) {
                ordersEntity.Low = ordersEntity.YClose;
            }
            if ([ordersEntity.Open floatValue]<=0) {
                ordersEntity.Open = ordersEntity.YClose;
            }
            if ([ordersEntity.New floatValue]<=0) {
                ordersEntity.New = ordersEntity.YClose;
            }
            if ([ordersEntity.High floatValue]>kHighPrice) {
                kHighPrice = [ordersEntity.High floatValue];
            }
            if ([ordersEntity.Low floatValue]<kLowPrice) {
                kLowPrice = [ordersEntity.Low floatValue];
            }
        }
        //STO
        [self.kchart drawChart:self.KChartValidRecords];

        [self.kchart setNeedsDisplay];
        
        [[WHGlobalHelper shareGlobalHelper] removeByKey:kHqKChartKey];
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

