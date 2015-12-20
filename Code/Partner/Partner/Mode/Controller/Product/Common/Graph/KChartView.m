//
//  KChartView.m
//  QianFangGuJie
//
//  Created by  rjt on 15/5/28.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import "KChartView.h"
#import "ProductKChartEntity.h"

@implementation KChartView{
    float margin_left;
    float margin_right;
    float margin_top;
    float margin_bottom;
    float x_hieight;
    float label_width;
    float per_ch_width ;
    
    int minutes;
    int percent;
    float mult;//比例放大因子
    float multheight;//高度放大因子
    float multwidth;//宽度放大因子
    
    int h_fill;
    int allpoitnt;
    
    CAShapeLayer * mainlayer;
    
    NSMutableArray * dashlines;//基准线
    CAShapeLayer * filllayer;//填充色
    CAShapeLayer * linelayer;//折线
    
    CAShapeLayer * chartlayer_top;
    CAShapeLayer * chartlayer_bottom;
    CALayer * xlabellayer_top;
    CALayer * xlabellayer_middle;
    CALayer * xlabellayer_bottom;
    
    CALayer * increaselayer;
    CALayer * reducelayer;
    
    int level;//放大倍数
    int per;//每格数量
    
    NSArray * _records;
    
    BOOL _isStock;
    BOOL _isMin;
    BOOL _needVol;//是否需要交易量均线
    
}

-(void)awakeFromNib{
    
    level = 4;
    per = 15;
    label_width = 80;
    dashlines = [[NSMutableArray alloc] init];
    margin_left = 0;
    margin_right= 0;
    margin_top = 0;
    margin_bottom = 0;
    x_hieight = 15;
    h_fill = 5;//填充10个格子
    per_ch_width = 6.5;
    mainlayer = [CAShapeLayer layer];
    
    chartlayer_top = [CAShapeLayer layer];
    //绘制图表边框
    chartlayer_top.borderWidth = 1;
    chartlayer_top.borderColor = kLineColor.CGColor;
    chartlayer_top.contentsGravity = kCAGravityResizeAspect;
    chartlayer_top.zPosition = -1;
    
    chartlayer_bottom = [CAShapeLayer layer];
    //绘制图表边框
    chartlayer_bottom.borderWidth = 1;
    chartlayer_bottom.borderColor = kLineColor.CGColor;
    chartlayer_bottom.contentsGravity = kCAGravityResizeAspect;
    
    xlabellayer_top = [CALayer layer];
    xlabellayer_bottom = [CALayer layer];
    xlabellayer_middle = [CALayer layer];
    
    increaselayer = [CALayer layer];
    increaselayer.contents = (__bridge id)([UIImage imageNamed:@"jia"].CGImage);
    reducelayer = [CALayer layer];
    reducelayer.contents = (__bridge id)([UIImage imageNamed:@"jian"].CGImage);
    
    [mainlayer addSublayer:chartlayer_top];
    [mainlayer addSublayer:chartlayer_bottom];
    
    [mainlayer addSublayer:xlabellayer_top];
    [mainlayer addSublayer:xlabellayer_bottom];
    [mainlayer addSublayer:xlabellayer_middle];
    
    [mainlayer addSublayer:reducelayer];
    [mainlayer addSublayer:increaselayer];
    
    [self.layer addSublayer:mainlayer];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapped:)];
    //点击一下响应，
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
    
}

-(void)installChart:(BOOL)resize stock:(BOOL)isStock minutes:(BOOL)isMin isNeedVol:(BOOL)needVol;{
    _needVol = needVol;
    _isStock = isStock;
    _isMin = isMin;
    
    if (_isMin) {
        level = 6;
        label_width = 150;
    }

    CGRect frame = self.frame;
    if(iPhone4 ){
        frame.size.width=307;
        if (resize) {
            frame.size.height = frame.size.height-180;
        }
    }else if(iPhone5){
        frame.size.width=307;
        if (resize) {
            frame.size.height = frame.size.height-93;
        }
    }
    else if(iPhone6Plus){
        frame.size.width=397;
        if (resize) {
            frame.size.height=frame.size.height+75;
        }
    }
    mainlayer.frame = CGRectMake(margin_left, margin_top, frame.size.width - margin_left - margin_right, frame.size.height - margin_top - margin_bottom);
}

-(void)singleTapped:(UITapGestureRecognizer *)sender{
    CALayer *l = [increaselayer hitTest:[sender locationInView:self]];
    if (l != nil) {
        if (level>1) {
            level--;
            if (level==1) {
                increaselayer.contents = (__bridge id)([UIImage imageNamed:@"jiadisabled"].CGImage);
            }else{
                increaselayer.contents = (__bridge id)([UIImage imageNamed:@"jia"].CGImage);
            }
            reducelayer.contents = (__bridge id)([UIImage imageNamed:@"jian"].CGImage);
        }
        [self setNeedsDisplay];
    }
    
    l = [reducelayer hitTest:[sender locationInView:self]];
    if (l != nil) {
        if (level<8) {
            level++;
            if (level==8) {
                reducelayer.contents = (__bridge id)([UIImage imageNamed:@"jiandisabled"].CGImage);
            }else{
                reducelayer.contents = (__bridge id)([UIImage imageNamed:@"jian"].CGImage);
            }
            increaselayer.contents = (__bridge id)([UIImage imageNamed:@"jia"].CGImage);
        }
        [self setNeedsDisplay];
    }
    
}

-(void)drawRect:(CGRect)rect{
    //清除layer
    for (int i = 0;i<dashlines.count;++i) {
        CALayer* layer = (CALayer*)dashlines[i];
        [layer removeFromSuperlayer];
        
    }
    [dashlines removeAllObjects];

    
    CGRect frame = mainlayer.frame;
    xlabellayer_top.frame = CGRectMake(0, 0 , frame.size.width , x_hieight);
    if (_needVol) {
        chartlayer_top.frame = CGRectMake(0, xlabellayer_top.frame.origin.y+xlabellayer_top.frame.size.height, frame.size.width ,(frame.size.height-(x_hieight*3))*0.7);
        xlabellayer_middle.frame = CGRectMake(0, chartlayer_top.frame.origin.y+chartlayer_top.frame.size.height, frame.size.width ,x_hieight);
        xlabellayer_middle.hidden = NO;
        chartlayer_bottom.frame = CGRectMake(0, xlabellayer_middle.frame.origin.y+xlabellayer_middle.frame.size.height, frame.size.width ,(frame.size.height-(x_hieight*3))*0.3);
        chartlayer_bottom.hidden = NO;
        xlabellayer_bottom.frame = CGRectMake(0, chartlayer_bottom.frame.origin.y+chartlayer_bottom.frame.size.height, frame.size.width ,x_hieight);
        
        if(iPhone6Plus){
            increaselayer.frame = CGRectMake(chartlayer_top.frame.size.width-33-30, chartlayer_top.frame.origin.y+chartlayer_top.frame.size.height-13-31, 33 ,31);
            reducelayer.frame = CGRectMake(increaselayer.frame.origin.x-12-33, increaselayer.frame.origin.y, 33 ,31);
        }else{
            increaselayer.frame = CGRectMake(chartlayer_top.frame.size.width-33-15, chartlayer_top.frame.origin.y+chartlayer_top.frame.size.height-13-31, 33 ,31);
            reducelayer.frame = CGRectMake(increaselayer.frame.origin.x-12-33, increaselayer.frame.origin.y, 33 ,31);
        }
    }else{
        chartlayer_top.frame = CGRectMake(0, xlabellayer_top.frame.origin.y+xlabellayer_top.frame.size.height, frame.size.width ,(frame.size.height-x_hieight*2));
        xlabellayer_middle.frame = CGRectMake(0, 0, 0 ,0);
        xlabellayer_middle.hidden = YES;
        chartlayer_bottom.frame = CGRectMake(0, 0, 0 ,0);
        chartlayer_bottom.hidden = YES;
        xlabellayer_bottom.frame = CGRectMake(0, chartlayer_top.frame.origin.y+chartlayer_top.frame.size.height, frame.size.width ,x_hieight);
        
        if(iPhone6Plus){
            increaselayer.frame = CGRectMake(chartlayer_top.frame.size.width-33-30, chartlayer_top.frame.origin.y+chartlayer_top.frame.size.height-13-40, 33 ,31);
            reducelayer.frame = CGRectMake(increaselayer.frame.origin.x-15-33, increaselayer.frame.origin.y, 33 ,31);
        }else{
            
            increaselayer.frame = CGRectMake(chartlayer_top.frame.size.width-33-15, chartlayer_top.frame.origin.y+chartlayer_top.frame.size.height-13-31, 33 ,31);
            reducelayer.frame = CGRectMake(increaselayer.frame.origin.x-12-33, increaselayer.frame.origin.y, 33 ,31);
        }
    }
    
    
    [self initData];
    
    [self drawPoint];
}
//画K线
-(void)drawPoint{
    NSInteger total = level * per;
    if ( total > _records.count) {
        total = _records.count;
    }
    
    //计算每份的宽度
    float per_candle_width = chartlayer_top.frame.size.width/(level*per);
    
    float ma5 = 0;float vol5 = 0;
    float ma10 = 0;float vol10 = 0;
    float ma20 = 0;
    float ma60 = 0;
    float maxprice =0,minprice =9999,maxvol=0,minvol=999999999999;
    
    ProductKChartRecordsEntity *firste = nil;
    ProductKChartRecordsEntity *laste = nil;

    NSMutableArray* points = [[NSMutableArray alloc] init];
    for (NSInteger i=_records.count-total; i < _records.count; ++i) {
        ProductKChartRecordsEntity *entity = (ProductKChartRecordsEntity*)_records[i];
        ma5 = entity.MA5 ; vol5 = entity.VOL5;
        ma10 = entity.MA10 ; vol10 = entity.VOL10;
        ma20 = entity.MA20 ;
        ma60 = entity.MA60 ;
        
        maxprice = [entity.High floatValue]> maxprice ? [entity.High floatValue] : maxprice;
        maxprice = entity.MA5> maxprice ? entity.MA5 : maxprice;
        maxprice = entity.MA10> maxprice ? entity.MA10 : maxprice;
        maxprice = entity.MA20> maxprice ? entity.MA20 : maxprice;
        maxprice = entity.MA60> maxprice ? entity.MA60 : maxprice;
        
        maxvol = [entity.Volume floatValue]> maxvol ? [entity.Volume floatValue] : maxvol;
        maxvol = entity.VOL5> maxvol ? entity.VOL5 : maxvol;
        maxvol = entity.VOL10> maxvol ? entity.VOL10 : maxvol;
        
        minprice = [entity.Low floatValue]< minprice ? [entity.Low floatValue] : minprice;
        minprice = entity.MA5< minprice && entity.MA5 ? entity.MA5 : minprice;
        minprice = entity.MA10< minprice && entity.MA10 ? entity.MA10 : minprice;
        minprice = entity.MA20< minprice && entity.MA20 != 0  ? entity.MA20 : minprice;
        minprice = entity.MA60< minprice && entity.MA60 != 0 ? entity.MA60 : minprice;
        
        minvol = [entity.Volume floatValue]< minvol ? [entity.Volume floatValue] : minvol;
        minvol = entity.VOL5 < minvol && entity.VOL5!=0 ? entity.VOL5 : minvol;
        minvol = entity.VOL10 < minvol && entity.VOL10!=0 ? entity.VOL10 : minvol;
        
        if (firste == nil) {
            firste = entity;
        }
        laste = entity;
        [points addObject:entity];
    }


    
    CATextLayer* revLayer = [CATextLayer layer];
    //画价格均线的均价
    if (ma5>0) {
        CATextLayer* layer = [CATextLayer layer];
        [dashlines addObject:layer];
        [xlabellayer_top addSublayer:layer];
//        layer.string = [NSString stringWithFormat:@"MA5 :%.2f",ma5];
        layer.string = [NSString stringWithFormat:([NSString stringWithFormat:@"MA5 :%%.%@f",self.jingdu]),ma5];
        layer.contentsScale = 2;
        layer.foregroundColor = FIVE_LINE_COLOR.CGColor ;
        layer.fontSize = 10.f; //字体的大小
        layer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        layer.frame = CGRectMake(0, 0, [layer.string length]*per_ch_width, x_hieight);
        revLayer = layer;
    }
    if (ma10>0) {
        CATextLayer* layer = [CATextLayer layer];
        [dashlines addObject:layer];
        [xlabellayer_top addSublayer:layer];
//        layer.string = [NSString stringWithFormat:@"MA10:%.2f",ma10];
        layer.string = [NSString stringWithFormat:([NSString stringWithFormat:@"MA10 :%%.%@f",self.jingdu]),ma10];
        layer.contentsScale = 2;
        layer.foregroundColor = TEN_LINE_COLOR.CGColor ;
        layer.fontSize = 10.f; //字体的大小
        layer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        layer.frame = CGRectMake(revLayer.frame.origin.x+revLayer.frame.size.width +8, 0, [layer.string length]*per_ch_width, x_hieight);
        revLayer = layer;
    }
    if (ma20>0) {
        CATextLayer* layer = [CATextLayer layer];
        [dashlines addObject:layer];
        [xlabellayer_top addSublayer:layer];
//        layer.string = [NSString stringWithFormat:@"MA20:%.2f",ma20];
        layer.string = [NSString stringWithFormat:([NSString stringWithFormat:@"MA20 :%%.%@f",self.jingdu]),ma20];
        layer.contentsScale = 2;
        layer.foregroundColor = TWENTY_LINE_COLOR.CGColor ;
        layer.fontSize = 10.f; //字体的大小
        layer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        layer.frame = CGRectMake(revLayer.frame.origin.x+revLayer.frame.size.width +8, 0, [layer.string length]*per_ch_width, x_hieight);
        revLayer = layer;
    }
    if (ma60>0) {
        CATextLayer* layer = [CATextLayer layer];
        [dashlines addObject:layer];
        [xlabellayer_top addSublayer:layer];
//        layer.string = [NSString stringWithFormat:@"MA60:%.2f",ma60];
        layer.string = [NSString stringWithFormat:([NSString stringWithFormat:@"MA60 :%%.%@f",self.jingdu]),ma60];
        layer.contentsScale = 2;
        layer.foregroundColor = SIXTY_LINE_COLOR.CGColor ;
        layer.fontSize = 10.f; //字体的大小
        layer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        layer.frame = CGRectMake(revLayer.frame.origin.x+revLayer.frame.size.width +8, 0, [layer.string length]*per_ch_width, x_hieight);
        revLayer = layer;
    }
    

    
    //画横分割虚线及价格
    float perheight = chartlayer_top.frame.size.height/4;
    [self drawHDash:CGPointMake(0, perheight * 0) width:chartlayer_top.frame.size.width price:(maxprice - (maxprice-minprice)/4*0)];
    [self drawHDash:CGPointMake(0, perheight * 1) width:chartlayer_top.frame.size.width price:(maxprice - (maxprice-minprice)/4*1)];
    [self drawHDash:CGPointMake(0, perheight * 2) width:chartlayer_top.frame.size.width price:(maxprice - (maxprice-minprice)/4*2)];
    [self drawHDash:CGPointMake(0, perheight * 3) width:chartlayer_top.frame.size.width price:(maxprice - (maxprice-minprice)/4*3)];
    [self drawHDash:CGPointMake(0, perheight * 4) width:chartlayer_top.frame.size.width price:(maxprice - (maxprice-minprice)/4*4)];
    
    
    //画竖分割虚线
    float perwidth = chartlayer_top.frame.size.width/2;
    [self drawVDash:CGPointMake(perwidth * 0, 0) height:chartlayer_top.frame.size.height];
    [self drawVDash:CGPointMake(perwidth * 1, 0) height:chartlayer_top.frame.size.height];
    [self drawVDash:CGPointMake(perwidth * 2, 0) height:chartlayer_top.frame.size.height];
    
    //画蜡烛图
    [self drawAllLine:points perWidth:per_candle_width maxVol:maxvol minVol:minvol maxPrice:maxprice minPrice:minprice];
    
    //画日期
    float perdate_width = xlabellayer_bottom.frame.size.width / (per*level);
    if (_isMin) {
        firste.date = firste.time;
        laste.date = laste.time;
    }
    CGRect rect = [self drawDate:firste.date point:CGPointMake(perdate_width * 0, 0)];
    if(![firste.date isEqualToString:laste.date]){
        float w = perdate_width * total;
        if ((rect.origin.x+rect.size.width) > perdate_width * total) {
            w = (rect.origin.x+rect.size.width)+5;
        }
        [self drawDate:laste.date point:CGPointMake(w , 0)];
    }
    //画中部文字
    [self drawMiddleVol:laste];
    //画最大交易量文字
    [self drawHighVol:maxvol];
    
}
/**
 计算交易量均值点
 */
-(void)drawAllLine:(NSMutableArray*)vols perWidth:(float)pw maxVol:(float)maxvol minVol:(float)minvol maxPrice:(float)maxprice minPrice:(float)minprice{

    UIBezierPath* ma5line = [UIBezierPath bezierPath];//5日均线
    UIBezierPath* ma10line = [UIBezierPath bezierPath];//10日均线
    UIBezierPath* ma20line = [UIBezierPath bezierPath];//20日均线
    UIBezierPath* ma60line = [UIBezierPath bezierPath];//60日均线
    UIBezierPath* vol5line = [UIBezierPath bezierPath];//交易量5日均线
    UIBezierPath* vol10line = [UIBezierPath bezierPath];//交易量10日均线
    if (maxvol == minvol) {
        minvol = 0;
    }
    float fPerVolHeight = chartlayer_bottom.frame.size.height/maxvol;
    float fPerPriceHeight = chartlayer_top.frame.size.height/(maxprice-minprice);
    
    float fPerVolShapWidth = pw*0.9;
    float fPerPriceShapWidth = pw*0.7;
    float prevVol5 = 0;float prevVol10 = 0;
    float prevMA5 = 0;float prevMA10 = 0;float prevMA20 = 0;float prevMA60 = 0;
    for (int i =0; i<vols.count; ++i) {

        ProductKChartRecordsEntity *entity = (ProductKChartRecordsEntity*)vols[i];
        if(!(entity.YClose==entity.High && entity.YClose==entity.Low)){//去除无效点
            if (prevVol5 == 0) {
                if (entity.VOL5>0) {
                    [vol5line moveToPoint:CGPointMake(pw*i+pw/2, fPerVolHeight*(maxvol-entity.VOL5))];
                }
                prevVol5 = entity.VOL5;
            }else{
                [vol5line addLineToPoint:CGPointMake(pw*i+pw/2, fPerVolHeight*(maxvol-entity.VOL5))];
                [vol5line moveToPoint:CGPointMake(pw*i+pw/2, fPerVolHeight*(maxvol-entity.VOL5))];
            }
            
            
            if (prevVol10 == 0) {
                if (entity.VOL10>0) {
                    [vol10line moveToPoint:CGPointMake(pw*i+pw/2, fPerVolHeight*(maxvol-entity.VOL10))];
                }
                prevVol10 = entity.VOL10;
            }else{
                [vol10line addLineToPoint:CGPointMake(pw*i+pw/2, fPerVolHeight*(maxvol-entity.VOL10))];
            }
            
            if (prevMA5 == 0 ) {
                if (entity.MA5>0) {
                    [ma5line moveToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA5))];
                }
                prevMA5 = entity.MA5;
            }else{
                [ma5line addLineToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA5))];
            }
            
            if (prevMA10==0) {
                if (entity.MA10>0) {
                    [ma10line moveToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA10))];
                }
                prevMA10 = entity.MA10;
            }else{
                [ma10line addLineToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA10))];
            }

            if (prevMA20==0) {
                if (entity.MA20>0) {
                    [ma20line moveToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA20))];
                }
                prevMA20 = entity.MA20;
            }else{
                [ma20line addLineToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA20))];
            }

            if (prevMA60==0) {
                if (entity.MA60>0) {
                    [ma60line moveToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA60))];
                }
                prevMA60 = entity.MA60;
            }else{
                [ma60line addLineToPoint:CGPointMake(pw*i+pw/2, fPerPriceHeight*(maxprice-entity.MA60))];
            }

            CGColorRef color = nil;
            if([entity.Open floatValue]<=[entity.New floatValue]){
                color = Color_Up_Red.CGColor;
            }else{
                color = Color_Down_Green.CGColor;
            }
            
            if (_needVol) {
                CAShapeLayer *vollayer = [CAShapeLayer layer];
                
                vollayer.backgroundColor = color;
                
                float h = fPerVolHeight * ( maxvol - [entity.Volume floatValue] );
                
                vollayer.frame = CGRectMake(pw*i,h+fPerVolHeight/2,fPerVolShapWidth,chartlayer_bottom.frame.size.height-h);
                
                [dashlines addObject:vollayer];
                [chartlayer_bottom addSublayer:vollayer];
            }
            
            
            CAShapeLayer *pricelayer = [CAShapeLayer layer];
            pricelayer.backgroundColor = color;
    //        float phy = fPerPriceHeight * ( maxprice - [entity.YClose floatValue]);
    //        float phn = fPerPriceHeight * ( maxprice - [entity.New floatValue]);
            
            float phy = fPerPriceHeight * ( maxprice - [entity.Open floatValue]);
            float phn = fPerPriceHeight * ( maxprice - [entity.New floatValue]);
            pricelayer.frame = CGRectMake(pw*i+pw/2-fPerPriceShapWidth/2,(phy<phn?phy:phn),fPerPriceShapWidth,fabs(phn-phy)>1?fabs(phn-phy):1);
            [dashlines addObject:pricelayer];
            [chartlayer_top addSublayer:pricelayer];
            

            float phh = fPerPriceHeight * ( maxprice - [entity.High floatValue] );
            float phl = fPerPriceHeight * ( maxprice - [entity.Low floatValue] );
            CAShapeLayer* pricelinelayer = [CAShapeLayer layer];
            pricelinelayer.frame = CGRectMake(pw*i+pw/2-0.5,phh,1,fabs(phh-phl));
            pricelinelayer.backgroundColor = color;
            [dashlines addObject:pricelinelayer];
            [chartlayer_top addSublayer:pricelinelayer];
        }
    }
    
    [self drawAvgLine:vol5line.CGPath lineColor:FIVE_LINE_COLOR.CGColor parentLayer:chartlayer_bottom];
    [self drawAvgLine:vol10line.CGPath lineColor:TEN_LINE_COLOR.CGColor parentLayer:chartlayer_bottom];
    
    [self drawAvgLine:ma5line.CGPath lineColor:FIVE_LINE_COLOR.CGColor parentLayer:chartlayer_top];
    [self drawAvgLine:ma10line.CGPath lineColor:TEN_LINE_COLOR.CGColor parentLayer:chartlayer_top];
    [self drawAvgLine:ma20line.CGPath lineColor:TWENTY_LINE_COLOR.CGColor parentLayer:chartlayer_top];
    [self drawAvgLine:ma60line.CGPath lineColor:SIXTY_LINE_COLOR.CGColor parentLayer:chartlayer_top];
}

-(void)drawAvgLine:(CGPathRef)path lineColor:(CGColorRef)color parentLayer:(CAShapeLayer*)layer{
    
    CAShapeLayer* malayer = [CAShapeLayer layer];
    malayer.path = path;
    malayer.strokeColor = color;
    malayer.fillColor = [UIColor clearColor].CGColor;
    malayer.lineJoin = kCALineJoinRound;
    malayer.lineCap = kCALineCapRound;
    [dashlines addObject:malayer];
    [layer addSublayer:malayer];
}


/**
 绘制中部文字
 */
/**
 绘制中部文字
 */
-(void)drawMiddleVol:(ProductKChartRecordsEntity*)entity{
    float vol_width = 37;
    
    
    CATextLayer* vollabel = [CATextLayer layer];
    vollabel.foregroundColor = [[UIColor blackColor] CGColor];
    vollabel.backgroundColor = [kLineColor CGColor];
    vollabel.frame =CGRectMake(0, 2 , vol_width, x_hieight-3);
    vollabel.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    vollabel.string = @"V O L";
    vollabel.contentsScale = 2;
    vollabel.fontSize = 10.f; //字体的大小
    
    [dashlines addObject:vollabel];
    [xlabellayer_middle addSublayer:vollabel];
    
    CATextLayer* layervol = [CATextLayer layer];
    
    float vol = [entity.Volume floatValue];
    if (_isStock) {
        vol = vol/100;
    }
    layervol.string = [NSString stringWithFormat:@"%.1f万",  vol/10000 ];
    layervol.contentsScale = 2;
    layervol.foregroundColor = FIVE_LINE_COLOR.CGColor ;
    layervol.fontSize = 10.f; //字体的大小
    layervol.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
    layervol.frame = CGRectMake(vollabel.frame.origin.x+vol_width+8, 2, per_ch_width*[layervol.string length] , x_hieight-3);
    [dashlines addObject:layervol];
    [xlabellayer_middle addSublayer:layervol];
    
    CATextLayer* layer5 = [CATextLayer layer];
    if (entity.VOL5>0) {
        [dashlines addObject:layer5];
        [xlabellayer_middle addSublayer:layer5];
        float vol5 = entity.VOL5;
        if (_isStock) {
            vol5 = vol5/100;
        }
        if(vol5>10000){
            layer5.string = [NSString stringWithFormat:@"MA5:%ld万",(long)[[NSNumber numberWithFloat: vol5/10000] integerValue]];
        }else{
            layer5.string = [NSString stringWithFormat:@"MA5:%ld",(long)[[NSNumber numberWithFloat: vol5] integerValue]];
        }
        layer5.contentsScale = 2;
        layer5.foregroundColor = FIVE_LINE_COLOR.CGColor ;
        layer5.fontSize = 10.f; //字体的大小
        layer5.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        layer5.frame = CGRectMake(layervol.frame.origin.x+vol_width+8, 2, per_ch_width*[layer5.string length] , x_hieight-3);
    }
    CATextLayer* layer10 = [CATextLayer layer];
    
    if (entity.VOL10>0) {
        [dashlines addObject:layer10];
        [xlabellayer_middle addSublayer:layer10];
        float vol10 = entity.VOL10;
        if (_isStock) {
            vol10 = vol10/100;
        }
        if(entity.VOL10>10000){
            layer10.string = [NSString stringWithFormat:@"MA10:%ld万",(long)[[NSNumber numberWithFloat: vol10/10000] integerValue]];
        }else{
            layer10.string = [NSString stringWithFormat:@"MA10:%ld",(long)[[NSNumber numberWithFloat: vol10] integerValue]];
        }
        layer10.contentsScale = 2;
        layer10.foregroundColor = TEN_LINE_COLOR.CGColor ;
        layer10.fontSize = 10.f; //字体的大小
        layer10.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        layer10.frame = CGRectMake(layer5.frame.origin.x+layer5.frame.size.width+8, 2, per_ch_width*[layer10.string length], x_hieight-3);
    }
}

/**
 绘制底部文字
 */
-(void)drawHighVol:(float)vol{
    
    CATextLayer* vollabel = [CATextLayer layer];
    vollabel.foregroundColor = [[UIColor blackColor] CGColor];
    if (_isStock) {
        vol = vol/100;
    }
    vollabel.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    if(vol>10000){
        vollabel.string = [NSString stringWithFormat:@"%ld万",(long)[[NSNumber numberWithFloat: vol/10000] integerValue]];
    }else{
        vollabel.string = [NSString stringWithFormat:@"%ld",(long)[[NSNumber numberWithFloat: vol] integerValue]];
    }
    vollabel.frame =CGRectMake(5, 5 , per_ch_width*[vollabel.string length], x_hieight);
    vollabel.contentsScale = 2;
    vollabel.fontSize = 10.f; //字体的大小
    
    [dashlines addObject:vollabel];
    [chartlayer_bottom addSublayer:vollabel];
}

/**
 绘制日期
 */
-(CGRect)drawDate:(NSString*)datestr point:(CGPoint)origin{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [dateFormatter dateFromString:datestr];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    CATextLayer* datelayer = [CATextLayer layer];
    datelayer.foregroundColor = [[UIColor blackColor] CGColor];
    if(origin.x-label_width < 0){
        datelayer.frame =CGRectMake(origin.x+5, origin.y , label_width, x_hieight);
        datelayer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
    }else if(origin.x+label_width/2 > xlabellayer_bottom.frame.size.width ){
        datelayer.frame =CGRectMake(origin.x-label_width, origin.y, label_width, x_hieight);
        datelayer.alignmentMode = kCAAlignmentRight;//字体的对齐方式
    }else{
        datelayer.frame =CGRectMake(origin.x-label_width/2, origin.y, label_width, x_hieight);
        datelayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    }

    if(_isMin){
        datelayer.string = [NSString stringWithFormat:@"%@",datestr];
    }else{
        datelayer.string = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:date]];
    }
    
    datelayer.contentsScale = 2;
    datelayer.fontSize = 10.f; //字体的大小
    
    [dashlines addObject:datelayer];
    
    [xlabellayer_bottom addSublayer:datelayer];
    return datelayer.frame;
}

/**
 绘制水平虚线
 */
-(void)drawHDash:(CGPoint)origin width:(CGFloat)w price:(float)price{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(w,0) ];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(origin.x, origin.y, w, 1);
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    
    // 3.0f设置虚线的宽度 [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 1=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],nil]];
    shapeLayer.path = path.CGPath;
    
    CATextLayer* pricelayer = [CATextLayer layer];
    pricelayer.foregroundColor = [[UIColor blackColor] CGColor];
    
    pricelayer.string = [NSString stringWithFormat:([NSString stringWithFormat:@"%%.%@f",self.jingdu]),price];
    pricelayer.contentsScale = 2;
    pricelayer.fontSize = 10.f; //字体的大小
    pricelayer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
    
    if(origin.y-x_hieight/2 < 0){
        pricelayer.frame =CGRectMake(origin.x+5, origin.y+5, 80, x_hieight);
        [shapeLayer setStrokeColor:[UIColor clearColor].CGColor];
        
    }else if(origin.y+x_hieight/2 > chartlayer_top.frame.size.height){
        pricelayer.frame =CGRectMake(origin.x+5, origin.y-x_hieight, 80, x_hieight);
        [shapeLayer setStrokeColor:[UIColor clearColor].CGColor];
    }else{
        pricelayer.frame =CGRectMake(origin.x+5, origin.y-x_hieight/2 , 80, x_hieight);
        [shapeLayer setStrokeColor:kLineColor.CGColor];
        
    }
    
    [dashlines addObject:pricelayer];
    [dashlines addObject:shapeLayer];
    [chartlayer_top addSublayer:shapeLayer];
    [chartlayer_top addSublayer:pricelayer];
}

/**
 绘制竖直虚线
 */
-(void)drawVDash:(CGPoint)origin height:(CGFloat)h{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(0,h) ];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(origin.x, origin.y, 1, h);
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:kLineColor.CGColor];
    // 3.0f设置虚线的宽度 [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 1=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],nil]];
    shapeLayer.path = path.CGPath;

    [dashlines addObject:shapeLayer];
    
    [chartlayer_top addSublayer:shapeLayer];

}


//初始化数据
-(void)initData{
    for (int i= 0 ; i < _records.count; ++i) {
        ProductKChartRecordsEntity *entity = (ProductKChartRecordsEntity*)_records[i];
        NSArray *tmp = [self avgFrom:i length:5];
        entity.MA5 = [tmp[0] floatValue];
        entity.VOL5 = [tmp[1]floatValue];
        
        tmp = [self avgFrom:i length:10];
        entity.MA10 = [tmp[0] floatValue];
        entity.VOL10 = [tmp[1]floatValue];
        
        tmp = [self avgFrom:i length:20];
        entity.MA20 = [tmp[0] floatValue];
        entity.VOL20 = [tmp[1]floatValue];
        
        tmp = [self avgFrom:i length:60];
        entity.MA60 = [tmp[0] floatValue];
        entity.VOL60 = [tmp[1]floatValue];
    }
}

-(NSArray*)avgFrom:(int)pos length:(int)len{//第一个是价格 ， 第二个是交易量
    float retPrice = 0;
    float retVol = 0;
    if (pos < _records.count && (pos + 1) >= len) {
        for (int i = 0; i < len ; i++) {
            ProductKChartRecordsEntity *entity = (ProductKChartRecordsEntity*)_records[pos-i];
            retPrice += [entity.New floatValue] ;
            if (_needVol) {
                retVol += [entity.Volume floatValue] ;
            }
        }
    }
    return @[[NSNumber numberWithFloat:retPrice/len],[NSNumber numberWithFloat:retVol/len]];
}



-(void)drawChart:(NSArray *)records {
    _records = records;
}

-(void)dealloc{
    NSLog(@"%@ has dealloc",[self class]);
}
@end
