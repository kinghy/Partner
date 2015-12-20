//
//  ProductGraphViewController.h
//  QianFangGuJie
//
//  Created by 余龙 on 15/2/1.
//  Copyright (c) 2015年 余龙. All rights reserved.
//
//图形管理类（分时、盘口、日k）

#import "EFBaseViewController.h"

@class ChartView,KChartView,Reachability,ProductChartMock,ProductVolChartMock,ProductKChartMock,ProductPanKouMock,ProductChartParam,ProductVolChartParam,ProductKChartParam,ProductPanKouParam;

@interface ProductGraphViewController : EFBaseViewController{
    UIButton *_selectedBtn;
    
    Reachability *reachability;
    
    BOOL _isPankou;
}


@property (weak, nonatomic) IBOutlet UIButton *chartBtn;
@property (weak, nonatomic) IBOutlet UIButton *partChartBtn;
@property (weak, nonatomic) IBOutlet UIButton *kChartBtn;


@property (weak, nonatomic) IBOutlet KChartView *kchart;
//@property (weak, nonatomic) IBOutlet CPBChartMarketView *chartView;
@property (weak, nonatomic) IBOutlet ChartView *chartView;
@property (weak, nonatomic) IBOutlet ChartView *partChartView;

@property (weak, nonatomic) IBOutlet UIView *chooseBarView;


@property(nonatomic,strong)NSArray* kChartRecords;
@property(nonatomic,strong)NSMutableArray* KChartValidRecords; //有效的K线数据
@property(nonatomic,strong)NSMutableArray* records;

@property(nonatomic,strong)NSMutableArray* sellPrices;

@property(strong,nonatomic)NSMutableArray* MAData;       //均线数据

@property (nonatomic,copy) NSString *stockCode;

@property BOOL needAnimation;

@property (strong,nonatomic) STOProductManager * manager;

-(void)refreshChart;

-(void)refreshHqChart;
-(void)refreshVolChart;
-(void)refreshKchart;
-(void)setJingdu:(NSString *)jd;
@end
