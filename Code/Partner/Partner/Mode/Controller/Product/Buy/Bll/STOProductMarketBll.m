//
//  STOProductMarketBll.m
//  Partner
//
//  Created by  rjt on 15/10/26.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductMarketBll.h"
#import "STOProductMarketSection.h"
#import "STOSearchViewController.h"
#import "STOProductBuyOrderViewController.h"
#import "ProductPanKouEntity.h"
#import "ProductGraphViewController.h"
#import "HandicapView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#define kSTOTagHQSection 200

@implementation STOProductMarketBll

-(void)loadBll{
    [super loadBll];
    self.manager = [STOProductManager shareSTOProductManager];
    [super loadBll];
    //添加数据刷新通知（code）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHqViewDataSource:) name:kHQViewNeedCodeString object:nil];
    
    StockEntity *entity = [STOProductManager shareSTOProductManager].chosedStock;
    if (entity == nil) {
        STOSearchViewController *controller = [[STOSearchViewController alloc] init];
        [self.controller presentViewController:controller animated:YES completion:nil];
    }
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(searchClicked)];
    [self.controller.navigationItem setRightBarButtonItem:item];
    
    [self getHqData];
    //初始化定时器
//    [self initTimer];
    
//    @weakify(self);
//    [[[[self.controller rac_signalForSelector:@selector(viewDidAppear:)] take:1] then:^RACSignal *{
//        @strongify(self)
//        return [[RACSignal interval:kHqOnceTaskVal onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[self.controller rac_signalForSelector:@selector(viewWillDisappear:)]];
//    }] subscribeNext:^(id x) {
//        @strongify(self)
//        DDLogInfo(@"kHqOnceTaskVal");
//        [self getHqData];
//    }];
    
}

-(void)controllerDidDisappear{
    [[WHTimerManager shareTimerManager] removeTarget:self notifyName:kHqRefresh];
    [self.handicapView removeFromSuperview];
}

-(void)controllerWillAppear{
    if (self.manager.chosedStock) {
        @weakify(self);
        [[[RACSignal interval:kHqOnceTaskVal onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:[self.controller rac_signalForSelector:@selector(viewWillDisappear:)]] subscribeNext:^(id x) {
            @strongify(self)
            [self getHqData];
        }];
        [self.mySection.graphicController refreshChart];//当view出现时手动触发定时器开关
    }
}

-(void)controllerDidAppear{
    if (self.manager.chosedStock) {
        [self setNavigationTitle:self.manager.chosedStock.stockName andCode:self.manager.chosedStock.codeShsz andImg:nil showImg:NO];
    
    }
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"STOProductMarketSection"] delegate:self];
    ProductPanKouEntity *entity = [ProductPanKouEntity entity];
    entity.tag = kSTOTagHQSection;
    [adpator addEntity:entity withSection:[STOProductMarketSection class]];
    adpator.fillParentEnabled = YES;
//    adpator.scrollEnabled = YES;
    return adpator;
}

-(void)getHqData{
    if (self.manager.chosedStock) {
        DEFINED_WEAK_SELF
        [self.manager refreshPankou:^(EFEntity *entity, NSError *error) {
            _self.pankouEntity= (ProductPanKouEntity *)entity;
            [_self.pAdaptorDict[kBllUniqueTable] notifyChanged];
        }];
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor willDidLoadSection:(EFSection *)section willDidLoadEntity:(EFEntity *)entity{
    if ([section isMemberOfClass:[STOProductMarketSection class]]) {
        STOProductMarketSection *s = (STOProductMarketSection *)section;
        self.mySection = s;
        //点击下一步
        [s.nextBtn addTarget:self action:@selector(nextClicked) forControlEvents:UIControlEventTouchUpInside];
        [s.btnDetailInfo addTarget:self action:@selector(clickDetailBtn) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity{
    if ([section isMemberOfClass:[STOProductMarketSection class]]) {
        STOProductMarketSection *s =  (STOProductMarketSection *)section;
        ProductPanKouEntity *e = self.pankouEntity;
        
        s.currentPrice.hidden = NO;
        s.rhythmLab.hidden = NO;
        s.percentLab.hidden = NO;
    
        ProductPanKouEntity *pankouen = e;
        if ([pankouen.stockcode isEqualToString:e.stockcode]) {
            s.openLab.text = [NSString stringWithFormat:@"%.2f", [pankouen.Open floatValue]];
            if ([pankouen.Open floatValue]>[pankouen.YClose floatValue]) {
                s.openLab.textColor = Color_Up_Red;
            }else if ([pankouen.Open floatValue]==[pankouen.YClose floatValue]){
                s.openLab.textColor = Color_DS_Gray;
            }else{
                s.openLab.textColor = Color_Down_Green;
            }
            
            s.closeLab.text = [NSString stringWithFormat:@"%.2f", [pankouen.YClose floatValue]];
            s.closeLab.textColor = Color_DS_Gray;
            
            s.highestLab.text = [NSString stringWithFormat:@"%.2f", [pankouen.High floatValue]];
            if ([pankouen.High floatValue]>[pankouen.YClose floatValue]) {
                s.highestLab.textColor = Color_Up_Red;
            }else if ([pankouen.High floatValue]==[pankouen.YClose floatValue]){
                s.highestLab.textColor = Color_DS_Gray;
            }else{
                s.highestLab.textColor = Color_Down_Green;
            }
            
            s.lowestLab.text =[NSString stringWithFormat:@"%.2f", [pankouen.Low floatValue]];
            if ([pankouen.Low floatValue]>[pankouen.YClose floatValue]) {
                s.lowestLab.textColor = Color_Up_Red;
            }else if ([pankouen.Low floatValue]==[pankouen.YClose floatValue]){
                s.lowestLab.textColor = Color_DS_Gray;
            }else{
                s.lowestLab.textColor = Color_Down_Green;
            }
            s.currentPrice.text = e.stockcode ? [NSString stringWithFormat:@"%.2f",[e.New floatValue]] : @"——";
            
            //还原基本设置
            //            s.nextBtn.backgroundColor = [UIColor whiteColor];
            //            [s.nextBtn setTitleColor:Color_Bg_007aff forState:UIControlStateNormal];
//            s.nextBtn.backgroundColor = Color_Confirm_Blue;
//            [s.nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [s.nextBtn setTitle:@"点 买" forState:UIControlStateNormal];
//            s.nextBtn.enabled = YES;
        }
        
        //当为禁买股，按钮变灰、显示禁买股
        
        //显示stockName，stockCode
        s.stockNameLab.text = self.manager.chosedStock.stockName;
        s.stockCodeLab.text = self.manager.chosedStock.codeShsz ? self.manager.chosedStock.codeShsz : self.manager.chosedStock.stockCode;
        
        if (e.New && [e.New doubleValue]==0) {//未开盘显示
            //            s.viewColor.backgroundColor = Color_Btn_Disabled;
            s.currentPrice.text = @"——";
            //无需展示当前价、涨跌，涨跌幅
            s.rhythmLab.text = @"——";
            s.percentLab.text = @"——";
            
            s.openLab.text = @"——";
            if([e.YClose doubleValue]!=0){
                s.closeLab.text = [NSString stringWithFormat:@"%.2f", [e.YClose floatValue]];
            }else{
                s.closeLab.text = @"——";
                s.closeLab.textColor = Color_Bg_757575;
            }
            
            s.highestLab.text = @"——";
            s.lowestLab.text = @"——";
            
            s.currentPrice.textColor = Color_Bg_757575;
            s.rhythmLab.textColor = Color_Bg_757575;
            s.percentLab.textColor = Color_Bg_757575;
            
            s.openLab.textColor = Color_Bg_757575;
            s.highestLab.textColor = Color_Bg_757575;
            s.lowestLab.textColor = Color_Bg_757575;
            
        }else if (e.New) {//UI数据映射,(有数值进行展示)
            /* 10.35是涨跌  最新价-昨收盘价
             * 10.35%是涨/跌幅 (最新价-昨收盘价) /昨收盘价 */
            
            NSString *rhythm = @"——" ;
            NSString *percent = @"——";
            if (([e.New doubleValue] - [e.YClose doubleValue]) > 0 ) {
                rhythm = [NSString stringWithFormat:@"+%.2f",[e.New doubleValue] - [e.YClose doubleValue]];
            } else  {
                rhythm = [NSString stringWithFormat:@"%.2f",[e.New doubleValue] - [e.YClose doubleValue]];
            }
            s.rhythmLab.text = e.stockcode ? rhythm : @"——";
            
            if ((([e.New doubleValue] - [e.YClose doubleValue]) / [e.YClose doubleValue] * 100) > 0) {
                percent = [NSString stringWithFormat:@"+%.2f%%",([e.New doubleValue] - [e.YClose doubleValue]) / [e.YClose doubleValue] * 100];
            } else {
                percent = [NSString stringWithFormat:@"%.2f%%",([e.New doubleValue] - [e.YClose doubleValue]) / [e.YClose doubleValue] * 100];
            }
            float precentNumber = ([e.New doubleValue] - [e.YClose doubleValue]) / [e.YClose doubleValue] * 100;
//            if (precentNumber>=8||precentNumber<=-8) {
//                [self.controller showTitleImg];
//            }else if([self.isDelist isEqualToString:kMyConstantString3]){
//                [self.controller hideTitleImg];
//            }
            s.percentLab.text = e.stockcode ? percent : @"——";
            
            if ([s.rhythmLab.text floatValue] > 0) {
                //                s.viewColor.backgroundColor = Color_Up_Red;
                s.currentPrice.textColor = Color_Up_Red;
                s.rhythmLab.textColor = Color_Up_Red;
                s.percentLab.textColor = Color_Up_Red;
            }else if([s.rhythmLab.text floatValue] == 0){
                s.currentPrice.textColor = Color_DS_Gray;
                s.rhythmLab.textColor = Color_DS_Gray;
                s.percentLab.textColor = Color_DS_Gray;
            }else {
                //                s.viewColor.backgroundColor = Color_Down_Green;
                s.currentPrice.textColor = Color_Down_Green;
                s.rhythmLab.textColor = Color_Down_Green;
                s.percentLab.textColor = Color_Down_Green;
            }
            
            if (!e.stockcode) {
                //                s.viewColor.backgroundColor = Color_Btn_Disabled;
            }
            
        }
        
    }
}

- (void) setNavigationTitle:(NSString *)stockName andCode:(NSString *)stockCode andImg:(UIImage*)img showImg:(BOOL)show{
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, -10, 100, 19)];
    titleLabel.text=stockName;
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    titleLabel.textAlignment=NSTextAlignmentCenter;
    
    UILabel *titleCode=[[UILabel alloc]initWithFrame:CGRectMake(0, 13, 100, 15)];
    if (stockCode!=nil) {
        titleCode.text=[NSString stringWithFormat:@"%@",stockCode];
    }else{
        titleCode.text=@"";
    }
    [titleCode setFont:[UIFont systemFontOfSize:13]];
    titleCode.textAlignment=NSTextAlignmentCenter;
    titleCode.textColor=[UIColor colorWithRed:112/255.0 green:142/255.0 blue:178/255.0 alpha:1.0];
    
    UIView *titleview=[[UIView alloc]initWithFrame:titleLabel.frame];
    [titleview addSubview:titleLabel];
    [titleview addSubview:titleCode];
    
//    if (img) {
//        [titleImgView removeFromSuperview];
//        titleImgView = [[UIImageView alloc] initWithImage:img];
//        titleImgView.frame = CGRectMake(titleLabel.frame.size.width, titleLabel.frame.origin.y+2, 38, 15);
//        titleImgView.hidden = !show;
//        [titleview addSubview:titleImgView];
//    }
//    self.titleView = titleview;
    self.controller.navigationItem.titleView = titleview;
}

-(void)clickDetailBtn{
    if(!self.handicapView){
        NSString *code = self.manager.chosedStock.stockCode;
        if([code isEqualToString:@"399001"]||[code isEqualToString:@"sh.999999"]){
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"Handicap4IndexView" owner:self options:nil];
            self.handicapView = [nib objectAtIndex:0];
        }else{
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"HandicapView" owner:self options:nil];
            self.handicapView = [nib objectAtIndex:0];
        }
    }
    [self refreshPankouDeatail];
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.handicapView];
}

-(void)refreshPankouDeatail{
    if (self.handicapView) {
        ProductPanKouEntity *pankouen = (ProductPanKouEntity *)[[WHGlobalHelper shareGlobalHelper]get:kPankouKey];
        
        self.handicapView.open.text=[NSString stringWithFormat:@"%.2f",[pankouen.Open floatValue]];
        self.handicapView.high.text=[NSString stringWithFormat:@"%.2f",[pankouen.High floatValue]];
        self.handicapView.price_max.text=[NSString stringWithFormat:@"%.2f",[pankouen.price_max floatValue]];
        float buyall = [pankouen.BuyVol1 floatValue]+[pankouen.BuyVol2 floatValue]+[pankouen.BuyVol3 floatValue]+[pankouen.BuyVol4 floatValue]+[pankouen.BuyVol5 floatValue];
        float sellall = [pankouen.SellVol1 floatValue]+[pankouen.SellVol2 floatValue]+[pankouen.SellVol3 floatValue]+[pankouen.SellVol4 floatValue]+[pankouen.SellVol5 floatValue];
        if((buyall+sellall)!=0){
            self.handicapView.transactionRate.text=[NSString stringWithFormat:@"%.2f%%",100*(buyall-sellall)/(buyall+sellall)];
            self.handicapView.transactionDif.text=[NSString stringWithFormat:@"%f",(buyall-sellall)/100];
        }else{
            self.handicapView.transactionRate.text=@"0";
            self.handicapView.transactionDif.text=@"0";
        }
        
        if(pankouen.amount==nil){
            self.handicapView.amount.text=@"0";
        }else{
            self.handicapView.amount.text=[NSString stringWithFormat:@"%f",[pankouen.amount floatValue]*10000];
        }
        
        self.handicapView.yClose.text=[NSString stringWithFormat:@"%.2f",[pankouen.YClose floatValue]];
        self.handicapView.low.text=[NSString stringWithFormat:@"%.2f",[pankouen.Low floatValue]];
        self.handicapView.price_min.text=[NSString stringWithFormat:@"%.2f",[pankouen.price_min floatValue]];
        self.handicapView.volume.text=[NSString stringWithFormat:@"%f",[pankouen.volume floatValue]/100];
        
        [self.handicapView fixColor];
    }
}



-(void)nextClicked{
    STOProductBuyOrderViewController *controller = [[STOProductBuyOrderViewController alloc] init];
    [self.controller.navigationController pushViewController:controller animated:YES];
}

- (void)dealloc {
    //移除通知
    [[WHTimerManager shareTimerManager] removeTarget:self notifyName:kHqRefresh];
}
@end
