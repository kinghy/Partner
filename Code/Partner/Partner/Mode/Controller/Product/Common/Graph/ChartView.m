//
//  ChartView.m
//  chart
//
//  Created by  rjt on 15/5/27.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import "ChartView.h"
#import "Grid.h"
#import "ProductPanKouEntity.h"

@interface ChartView(){
    float margin_left;
    float margin_right;
    float margin_top;
    float margin_bottom;
    float x_hieight;
    
    int minutes;
    NSArray* splittime;//时间分割
    NSArray* splitdiffer;//每个点之间的间隔分钟
    
    int percent;
    float mult;//比例放大因子
    float multheight;//高度放大因子
    float multwidth;//宽度放大因子
    
    int h_fill;
    int allpoint;
    
    CAShapeLayer * mainlayer;
    CALayer * handicaplayer;
    
    NSMutableArray * handicaplines;//基准线
    NSMutableArray * pricelines;//基准线
    NSMutableArray * vollines;//基准线
    CAShapeLayer * filllayer;//填充色
    CAShapeLayer * linelayer;//折线
    
    CAShapeLayer * chartlayer;
    CAShapeLayer * vollayer;
    CALayer * buyhandlayer;
    CALayer * sellhandlayer;
    CALayer * xlabellayer;
    
    CALayer *rectlayer;
    
    NSMutableArray* grids;//模型二维数组
    NSMutableArray* points;//有值得grid
    
    float abshigh;//当前波动的绝对峰值
    float abshighprice;//当前波动的绝对峰值
    
    float _close;//昨收价
    float _high;//最高价
    float _low; //最低价
    float _open;//开盘价
    
    NSArray* _prices;//价格列表
    NSArray* _vols;//交易量列表
    NSString* _time;//市场时间
    
    ProductPanKouEntity* _handicap;
    
    CALayer *cycle;                 //最新价，跳动的圆
    int times;
    NSTimer *timer;
    BOOL isFirstPrice;
    BOOL isFirstVol;
    
    BOOL _isStock;
    
    BOOL _isLine;
    BOOL _isHistogram;
    BOOL _isHandicap;
}

@end

@implementation ChartView

-(void)awakeFromNib{
    isFirstPrice = YES;
    isFirstVol = YES;
    
    //定义常量
    margin_left = 0;
    margin_right= 0;
    margin_top = 0;
    margin_bottom = 0;
    x_hieight = 15;
    h_fill = 5;//填充10个格子
    
    percent = 200  + 1;//上下各20点,加上0线
    
    allpoint = percent + h_fill*2;
}

-(void)drawRect:(CGRect)rect{

}

-(void)installChartWithLine:(BOOL)line histogram:(BOOL)histogram handicap:(BOOL)handicap{
    [self installChartWithLine:line histogram:histogram handicap:handicap resize:YES];
}

-(void)installChartWithLine:(BOOL)line histogram:(BOOL)histogram handicap:(BOOL)handicap resize:(BOOL)resize{
    _isLine = line;
    _isHistogram = histogram;
    _isHandicap = handicap;

    //获取当前尺寸
    CGRect viewframe = self.frame;
    if(iPhone4 ){
        viewframe.size.width=307;
        if (resize) {
            viewframe.size.height = viewframe.size.height-180;
        }
    }else if(iPhone5){
        viewframe.size.width=307;
        if (resize) {
            viewframe.size.height = viewframe.size.height-93;
        }
    }
    else if(iPhone6Plus){
        viewframe.size.width=397;
        if (resize) {
            viewframe.size.height=viewframe.size.height+75;
        }
    }

    
    [points removeAllObjects];
    points = [[NSMutableArray alloc] init];
    
    //定义左右分割
    float splitLeft = 0.71;
    float splitRight = 0.29;
    float splitTop = 0.72;
    float splitBottom = 0.28;
    [mainlayer removeFromSuperlayer];
    
    mainlayer = [CAShapeLayer layer];
    mainlayer.frame = CGRectMake(margin_left, margin_top, (viewframe.size.width - margin_left - margin_right)*((_isLine||_isHistogram)*splitLeft+(!_isHandicap)*splitRight), viewframe.size.height - margin_top - margin_bottom);
    [self.layer addSublayer:mainlayer];
    
    mainlayer.hidden=YES;
    
    //组装折线图
    if (_isLine) {
        CGRect frame = mainlayer.frame;
        
        //清除基准线
        for (int i = 0;i<pricelines.count;++i) {
            CALayer* layer = (CALayer*)pricelines[i];
            [layer removeFromSuperlayer];
            //        [dashlines removeObject:layer];
            
        }
        [pricelines removeAllObjects];
        
        pricelines = [[NSMutableArray alloc] init];
        [chartlayer removeFromSuperlayer];
        chartlayer = [CAShapeLayer layer];
        chartlayer.frame = CGRectMake(0, 0, frame.size.width+1, (frame.size.height - x_hieight));
        //绘制图表边框
        chartlayer.borderWidth = 1;
        chartlayer.borderColor = kLineColor.CGColor;
        chartlayer.contentsGravity = kCAGravityResizeAspect;
        chartlayer.frame = CGRectMake(0, 0, frame.size.width+1, (frame.size.height - x_hieight)*(_isLine*splitTop+(!_isHistogram)*splitBottom));
        //绘制原点
        if (cycle==nil) {
            [cycle removeFromSuperlayer];
            cycle = [CALayer layer];
            UIImage *img = [UIImage imageNamed:@"dotcycle.png"];
            cycle.frame = CGRectMake(-100, -100, img.size.width, img.size.height);
            cycle.contents = (__bridge id)(img.CGImage);
            cycle.zPosition = 100;
            cycle.hidden = YES;
            //cycle.position = CGPointMake(cycle.position.x+(img.size.width/2), cycle.position.y+(img.size.height/2));
        }
        times = -1;
        
        //绘制底部文字
        [xlabellayer removeFromSuperlayer];
        xlabellayer = [CALayer layer];
        xlabellayer.frame = CGRectMake(0, frame.size.height-x_hieight, frame.size.width, x_hieight);
        
        
        [mainlayer addSublayer:chartlayer];
        [mainlayer addSublayer:xlabellayer];
    }
    
    //组装柱状图
    if (_isHistogram) {
        CGRect frame = mainlayer.frame;
        //清除基准线
        for (int i = 0;i<vollines.count;++i) {
            CALayer* layer = (CALayer*)vollines[i];
            [layer removeFromSuperlayer];
            //        [dashlines removeObject:layer];
            
        }
        [vollines removeAllObjects];
        vollines = [[NSMutableArray alloc] init];
        [vollayer removeFromSuperlayer];
        vollayer = [CAShapeLayer layer];
        //绘制图表边框
        vollayer.borderWidth = 1;
        vollayer.borderColor = kLineColor.CGColor;
        vollayer.contentsGravity = kCAGravityResizeAspect;
        vollayer.frame = CGRectMake(0, (frame.size.height - x_hieight)*(_isLine*splitTop), frame.size.width+1, (frame.size.height - x_hieight)*((!_isLine)*splitTop+_isHistogram*splitBottom));
        vollayer.hidden = NO;
        [mainlayer addSublayer:vollayer];
    }
    
    //组装盘口
    if (_isHandicap) {
        //清除基准线
        for (int i = 0;i<handicaplines.count;++i) {
            CALayer* layer = (CALayer*)handicaplines[i];
            [layer removeFromSuperlayer];
            //        [dashlines removeObject:layer];
            
        }
        [vollines removeAllObjects];
        handicaplines = [[NSMutableArray alloc] init];
        [handicaplayer removeFromSuperlayer];
        handicaplayer = [CALayer layer];
        
        [buyhandlayer removeFromSuperlayer];
        buyhandlayer = [CALayer layer];
        //绘制图表边框
        buyhandlayer.borderWidth = 1;
        buyhandlayer.borderColor = kLineColor.CGColor;
        buyhandlayer.contentsGravity = kCAGravityResizeAspect;
        [sellhandlayer removeFromSuperlayer];
        sellhandlayer = [CALayer layer];
        //绘制图表边框
        sellhandlayer.borderWidth = 1;
        sellhandlayer.borderColor = kLineColor.CGColor;
        sellhandlayer.contentsGravity = kCAGravityResizeAspect;
        handicaplayer.frame = CGRectMake(margin_left+(viewframe.size.width - margin_left - margin_right)*((_isLine||_isHistogram)*splitLeft), margin_top, (viewframe.size.width - margin_left - margin_right)*((!(_isLine||_isHistogram))*splitLeft+_isHandicap*splitRight), viewframe.size.height - margin_top - margin_bottom-x_hieight);
        [handicaplayer addSublayer:buyhandlayer];
        [handicaplayer addSublayer:sellhandlayer];
        
        [self.layer addSublayer:handicaplayer];
        handicaplayer.hidden = YES;
    }
    
}


-(void)left2rightPrice{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 1.f;
    animation.keyPath = @"bounds.size.width";
    animation.fromValue = @0;
    
    animation.toValue = [[NSNumber alloc] initWithFloat:chartlayer.frame.size.width];
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [filllayer addAnimation:animation forKey:nil];
    [linelayer addAnimation:animation forKey:nil];
    
    [self performSelector:@selector(showCycle) withObject:nil afterDelay:.7f ];
}

-(void)left2rightVol{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 1.f;
    animation.keyPath = @"bounds.size.width";
    animation.fromValue = @0;
    
    animation.toValue = [[NSNumber alloc] initWithFloat:vollayer.frame.size.width];
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [rectlayer addAnimation:animation forKey:nil];
}

/*!
 *  @brief  绘制分时图
 */
-(void)drawPrice{
    //清除基准线
    for (int i = 0;i<pricelines.count;++i) {
        CALayer* layer = (CALayer*)pricelines[i];
        [layer removeFromSuperlayer];
        //        [dashlines removeObject:layer];
        
    }
    [points removeAllObjects];
    [pricelines removeAllObjects];
    if(_prices && _isLine){
        mainlayer.hidden = NO;
        //绘制图表边框
        //    xlabellayer.borderWidth = 1;
        //    xlabellayer.borderColor = [UIColor redColor].CGColor;
        //算基准线
        
        if(_high!=0){//未开盘，微调
            abshighprice = fabs(_high-_close)>=fabs(_low-_close)?fabs(_high-_close):fabs(_low-_close);
        }else{
            abshighprice = 0.005*_close;
        }
        
        abshigh = abshighprice*1000/_close;
        if(abshigh!=0){
            mult = (percent-1)/2/abshigh;
        }else{
            mult = 0;
        }
        multheight = chartlayer.frame.size.height/allpoint;
        
        multwidth = chartlayer.frame.size.width/minutes;
        
        CGPoint basePoint= CGPointMake(0, ((allpoint-1)/2+1)*multheight);
        
        for (long i = 0; i<[_prices count]; ++i) {
            NSNumber *price = (NSNumber*)_prices[i];
            Grid *g = [[Grid alloc] init];
            g.percent = ([price floatValue]-_close)*100/_close;
            g.price = [price floatValue];
            g.x_grid = i ;
            [points addObject:g];
        }
        
        
        UIBezierPath* bezier = [UIBezierPath bezierPath];
        
        CGPoint beginPoint = CGPointMake(0, chartlayer.frame.size.height);
        CGPoint lastestPoint = CGPointMake(0, 0);
        
        float highPrice = 0;
        float lowPrice = 9999999;
        CGPoint highPoint,lowPoint;
        
        for (int i = 0; i<[points count]; ++i) {
            Grid *g = (Grid*)points[i];
            CGPoint p = [g getPointWithBasePoint:basePoint multWidth:multwidth multHeight:multheight*mult ];
            if (i==0) {
                [bezier moveToPoint:p];
            }else{
                [bezier addLineToPoint:p];
            }
            lastestPoint = p;
            if (g.price > highPrice) {
                highPrice = g.price;
                highPoint = p;
            }
            if (g.price < lowPrice) {
                lowPrice = g.price;
                lowPoint = p;
            }
        }

        [linelayer removeFromSuperlayer];
        linelayer = [CAShapeLayer layer];
        linelayer.path = bezier.CGPath;
        linelayer.lineWidth = 1;
        linelayer.strokeColor = [Color_Time_Line CGColor];
        linelayer.fillColor = [UIColor clearColor].CGColor;
        linelayer.lineJoin = kCALineJoinRound;
        linelayer.lineCap = kCALineCapRound;
        linelayer.frame = chartlayer.bounds;
        linelayer.masksToBounds = YES;
        linelayer.position =  CGPointMake(0,linelayer.position.y);
        linelayer.anchorPoint = CGPointMake(0,linelayer.anchorPoint.y);
        //将点移到最后一分钟的位置
        if (lastestPoint.x>0 && lastestPoint.x<(chartlayer.frame.size.width-1) && _high > 0) {//判断是否开盘
            cycle.frame = CGRectMake(lastestPoint.x-cycle.frame.size.width/2, lastestPoint.y-cycle.frame.size.height/2, cycle.frame.size.width, cycle.frame.size.height);
//            if(cycle.hidden && times>=0 && !isFirstVol){
//                cycle.hidden=NO;
//            }
        }else{
            cycle.hidden = YES;
        }
        [linelayer addSublayer:cycle];
        
        [bezier addLineToPoint:CGPointMake(lastestPoint.x, beginPoint.y)];
        [bezier addLineToPoint:CGPointMake(beginPoint.x, beginPoint.y)];
        //[bezier moveToPoint:CGPointMake(lastestPoint.x, bgpoint.y)];
        [bezier closePath];
        [filllayer removeFromSuperlayer];
        filllayer = [CAShapeLayer layer];
        filllayer.path = bezier.CGPath;
        filllayer.strokeColor = [UIColor clearColor].CGColor;
        filllayer.fillColor = [Color_Time_Fill CGColor];
        filllayer.zPosition = 0;
        filllayer.frame = chartlayer.bounds;
        filllayer.masksToBounds = YES;
        filllayer.position =  CGPointMake(0,filllayer.position.y);
        filllayer.anchorPoint = CGPointMake(0,filllayer.anchorPoint.y);
        
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        gradientLayer.startPoint = CGPointMake(0.5,1.0);
//        gradientLayer.endPoint = CGPointMake(0.5,0.0);
//        gradientLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//        [gradientLayer setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor yellowColor] CGColor], nil]];  ;
//        [gradientLayer setLocations:@[@0.5,@1]];
        
//        CAGradientLayer *mask = [CAGradientLayer layer];
//        mask.frame = filllayer.frame;
//        mask.startPoint = CGPointMake(0.5,1.0);
//        mask.endPoint = CGPointMake(0.5,0.0);
//        mask.frame = CGRectMake(0, highPoint.y, filllayer.bounds.size.width, filllayer.bounds.size.height-highPoint.y);
//        [mask setColors:[NSArray arrayWithObjects:(id)[[UIColor redColor] CGColor],(id)[[UIColor clearColor] CGColor], nil]];  ;
//        [mask setLocations:@[@0.1,@0.5]];
        
//        [filllayer setMask:mask];
        
        [chartlayer addSublayer:filllayer];
        
        [chartlayer addSublayer:linelayer];
        //初次进入的动画效果
        CGRect rect = chartlayer.bounds;
        rect.size.width = 0;
        if (_prices.count>0 && isFirstPrice) {
            isFirstPrice = NO;
            filllayer.frame = rect;
            linelayer.frame = rect;
            
            [self performSelector:@selector(left2rightPrice) withObject:nil afterDelay:1.f];
        }
        //[chartlayer addSublayer:filllayer];
        //    Grid *t = [[Grid alloc] init];
        //    t.x_grid = 0;
        //    t.y_grid = (percent - 1)/2+1;
        //
        //    CGPoint basepoint = [t getPointWithOrigin:origin width:gridwidth hieght:gridheight scaleOrigin:originpoint];
        //
        //    //基线
        [self drawHLine:basePoint width:chartlayer.frame.size.width price:_close percent:0 isDash:NO];
        [self drawHLine:CGPointMake(0, 0) width:chartlayer.frame.size.width price:_close+abshighprice percent:abshighprice*100/_close isDash:YES];
        
        [self drawHLine:beginPoint width:chartlayer.frame.size.width price:_close-abshighprice percent:(abshighprice*(-1))*100/_close isDash:YES];
        
        [self drawHLine:CGPointMake(0, basePoint.y/2) width:chartlayer.frame.size.width price:_close+abshighprice/2 percent:(abshighprice/2)*100/_close isDash:YES];
        
        [self drawHLine:CGPointMake(0, basePoint.y/2+basePoint.y) width:chartlayer.frame.size.width price:_close-abshighprice/2 percent:(abshighprice/2*(-1))*100/_close isDash:YES];
        
        //计算时间分割
        for (int i = 0 ; i<splittime.count; ++i) {
            float split = [(NSNumber*)splitdiffer[i] floatValue]/(minutes-1)*xlabellayer.frame.size.width;
            [self drawTime:CGPointMake(split,0 ) width:30 date:splittime[i]];
            if (i>0 && i<splittime.count-1) {
                [self drawVLine:CGPointMake(split,0 ) isDash:YES];
            }
        }
    }
}

/*!
 *  @brief  绘制分时图
 */
-(void)drawFreeStylePrice{
    //清除基准线
    for (int i = 0;i<pricelines.count;++i) {
        CALayer* layer = (CALayer*)pricelines[i];
        [layer removeFromSuperlayer];
        //        [dashlines removeObject:layer];
        
    }
    [points removeAllObjects];
    [pricelines removeAllObjects];
    if(_prices && _isLine){
        mainlayer.hidden = NO;
        //绘制图表边框
        //    xlabellayer.borderWidth = 1;
        //    xlabellayer.borderColor = [UIColor redColor].CGColor;
        //算基准线
        
        if(_high!=0){//未开盘，微调
            abshighprice = fabs(_high-_close)>=fabs(_low-_close)?fabs(_high-_close):fabs(_low-_close);
        }else{
            abshighprice = 0.005*_close;
        }
        
        abshigh = abshighprice*1000/_close;
        if(abshigh!=0){
            mult = (percent-1)/2/abshigh;
        }else{
            mult = 0;
        }
        multheight = chartlayer.frame.size.height/allpoint;
        
        multwidth = chartlayer.frame.size.width/minutes;
        
        CGPoint basePoint= CGPointMake(0, ((allpoint-1)/2+1)*multheight);
        
        for (long i = 0; i<[_prices count]; ++i) {
            NSNumber *price = (NSNumber*)_prices[i];
            Grid *g = [[Grid alloc] init];
            g.percent = ([price floatValue]-_close)*100/_close;
            g.price = [price floatValue];
            g.x_grid = i ;
            [points addObject:g];
        }
        
        
        UIBezierPath* bezier = [UIBezierPath bezierPath];
        
        CGPoint beginPoint = CGPointMake(0, chartlayer.frame.size.height);
        CGPoint lastestPoint = CGPointMake(0, 0);
        
        NSMutableArray* pointArray = [[NSMutableArray alloc] init];
        
        float highPrice = 0;
        float lowPrice = 9999999;
        CGPoint highPoint,lowPoint;
        
        for (int i = 0; i<[points count]; ++i) {
            Grid *g = (Grid*)points[i];
            CGPoint p = [g getPointWithBasePoint:basePoint multWidth:multwidth multHeight:multheight*mult ];
            [pointArray addObject:[NSValue valueWithCGPoint:p]];
            
            if (g.price > highPrice) {
                highPrice = g.price;
                highPoint = p;
            }
            if (g.price < lowPrice) {
                lowPrice = g.price;
                lowPoint = p;
            }
        }
        
        float avgPrice = (lowPrice+highPrice)/2;
        float avgPercent = (avgPrice/_close - 1)*100;
        float highPercent = (highPrice/_close - 1)*100;
        float lowPercent = (lowPrice/_close - 1)*100;
        
        float deviation = highPoint.y-1 ;//偏移量
        float zoom = 1;
        if(lowPoint.y-highPoint.y>0){
            zoom = (chartlayer.frame.size.height-1)/(lowPoint.y-highPoint.y+1);//放大
        }
        
        for (int i = 0; i<[pointArray count]; ++i) {
            NSValue *p = (NSValue*)pointArray[i];
            CGPoint cp = [p CGPointValue];
            cp = CGPointMake(cp.x, (cp.y-deviation)*zoom);
            if (i==0) {
                [bezier moveToPoint:cp];
            }else{
                [bezier addLineToPoint:cp];
            }
            lastestPoint = cp;
        }
        
        [linelayer removeFromSuperlayer];
        linelayer = [CAShapeLayer layer];
        linelayer.path = bezier.CGPath;
        linelayer.lineWidth = 1;
        linelayer.strokeColor = [[UIColor colorWithRed:100/255.0 green:132/255.0 blue:180/255.0 alpha:1.0] CGColor];
        linelayer.fillColor = [UIColor clearColor].CGColor;
        linelayer.lineJoin = kCALineJoinRound;
        linelayer.lineCap = kCALineCapRound;
        linelayer.frame = chartlayer.bounds;
        linelayer.masksToBounds = YES;
        linelayer.position =  CGPointMake(0,linelayer.position.y);
        linelayer.anchorPoint = CGPointMake(0,linelayer.anchorPoint.y);
        //将点移到最后一分钟的位置
        if (lastestPoint.x>0 && lastestPoint.x<(chartlayer.frame.size.width-1) && _high > 0) {//判断是否开盘
            cycle.frame = CGRectMake(lastestPoint.x-cycle.frame.size.width/2, lastestPoint.y-cycle.frame.size.height/2, cycle.frame.size.width, cycle.frame.size.height);
            //            if(cycle.hidden && times>=0 && !isFirstVol){
            //                cycle.hidden=NO;
            //            }
        }else{
            cycle.hidden = YES;
        }
        [linelayer addSublayer:cycle];
        
        [bezier addLineToPoint:CGPointMake(lastestPoint.x, beginPoint.y)];
        [bezier addLineToPoint:CGPointMake(beginPoint.x, beginPoint.y)];
        //[bezier moveToPoint:CGPointMake(lastestPoint.x, bgpoint.y)];
        [bezier closePath];
        [filllayer removeFromSuperlayer];
        filllayer = [CAShapeLayer layer];
        filllayer.path = bezier.CGPath;
        filllayer.strokeColor = [UIColor clearColor].CGColor;
        filllayer.fillColor = [[UIColor colorWithRed:143/255.0 green:189/255.0 blue:255/255.0 alpha:1.0] CGColor];
        filllayer.zPosition = 0;
        filllayer.frame = chartlayer.bounds;
        filllayer.masksToBounds = YES;
        filllayer.position =  CGPointMake(0,filllayer.position.y);
        filllayer.anchorPoint = CGPointMake(0,filllayer.anchorPoint.y);
        [chartlayer addSublayer:filllayer];
        
        [chartlayer addSublayer:linelayer];
        //初次进入的动画效果
        CGRect rect = chartlayer.bounds;
        rect.size.width = 0;
        if (_prices.count>0 && isFirstPrice) {
            isFirstPrice = NO;
            filllayer.frame = rect;
            linelayer.frame = rect;
            
            [self performSelector:@selector(left2rightPrice) withObject:nil afterDelay:1.f];
        }
        //[chartlayer addSublayer:filllayer];
        //    Grid *t = [[Grid alloc] init];
        //    t.x_grid = 0;
        //    t.y_grid = (percent - 1)/2+1;
        //
        //    CGPoint basepoint = [t getPointWithOrigin:origin width:gridwidth hieght:gridheight scaleOrigin:originpoint];
        //
        //    //基线
        
        if (pointArray.count>0) {
            [self drawHLine:basePoint width:chartlayer.frame.size.width price:avgPrice percent:avgPercent isDash:NO];
            [self drawHLine:CGPointMake(0, 0) width:chartlayer.frame.size.width price:highPrice percent:highPercent isDash:YES];
            //
            [self drawHLine:beginPoint width:chartlayer.frame.size.width price:lowPrice percent:lowPercent isDash:YES];
        }
//        [self drawHLine:CGPointMake(0, basePoint.y/2) width:chartlayer.frame.size.width price:_close+abshighprice/2 percent:(abshighprice/2)*100/_close isDash:YES];
////
//        [self drawHLine:CGPointMake(0, basePoint.y/2+basePoint.y) width:chartlayer.frame.size.width price:_close-abshighprice/2 percent:(abshighprice/2*(-1))*100/_close isDash:YES];
        
        //计算时间分割
        for (int i = 0 ; i<splittime.count; ++i) {
            float split = [(NSNumber*)splitdiffer[i] floatValue]/(minutes-1)*xlabellayer.frame.size.width;
            [self drawTime:CGPointMake(split,0 ) width:30 date:splittime[i]];
            if (i>0 && i<splittime.count-1) {
                [self drawVLine:CGPointMake(split,0 ) isDash:YES];
            }

        }
    }
}

//绘制5档买卖
-(void)drawHandicap{
    //清除基准线
    for (int i = 0;i<handicaplines.count;++i) {
        CALayer* layer = (CALayer*)handicaplines[i];
        [layer removeFromSuperlayer];
    }
    [handicaplines removeAllObjects];
    if(_isHandicap && _handicap){
        handicaplayer.hidden = NO;
        float fontSize = 11.f;
        float fontHight = 16;
        if(iPhone4 || iPhone5){
            fontSize = 9.f;
            fontHight = 10;
        }
        CGRect frame = handicaplayer.frame;
        sellhandlayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        buyhandlayer.frame = CGRectMake(0, frame.size.height/2-1, frame.size.width, frame.size.height/2+1);
        
        float perHeight = handicaplayer.frame.size.height/10;
        float perWidth = handicaplayer.frame.size.width/10;
        //绘制卖5档
        for (int i=4; i>=0; --i) {
            CATextLayer *sellLabel = [CATextLayer layer];
            sellLabel.string = [NSString stringWithFormat:@"卖%d",i+1];
            sellLabel.contentsScale = 2;
            sellLabel.foregroundColor = [Color_Bg_Black1 CGColor];
            sellLabel.fontSize = fontSize; //字体的大小
            sellLabel.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
            sellLabel.frame =CGRectMake(6, (i*(-1)+4)*perHeight + (perHeight/2)-(fontHight/2), perWidth*3-6, fontHight);
            
            [sellhandlayer addSublayer:sellLabel];
            [handicaplines addObject:sellLabel];
            
            CATextLayer *sellpriceLabel = [CATextLayer layer];
            NSString *price = [_handicap valueForKey:[NSString stringWithFormat:@"_Sell%d",i+1]];
            sellpriceLabel.string = [NSString stringWithFormat:@"%.2f",[price floatValue]];
            sellpriceLabel.contentsScale = 2;
            if([price floatValue]==0){
                sellpriceLabel.foregroundColor = (Color_Bg_GrayFont.CGColor);
                sellpriceLabel.string = @"——";;
            }else if ([price floatValue] < [_handicap.YClose floatValue]) {
                sellpriceLabel.foregroundColor = (Color_Down_Green.CGColor);
            }else{
                sellpriceLabel.foregroundColor = (Color_Up_Red.CGColor);
                
            }
            sellpriceLabel.fontSize = fontSize; //字体的大小
            sellpriceLabel.alignmentMode = kCAAlignmentRight;//字体的对齐方式
            sellpriceLabel.frame =CGRectMake(perWidth*3, (i*(-1)+4)*perHeight + (perHeight/2)-(fontHight/2), perWidth*3.8, fontHight);
            [sellhandlayer addSublayer:sellpriceLabel];
            [handicaplines addObject:sellpriceLabel];
            
            CATextLayer *sellvolLabel = [CATextLayer layer];
            NSString *vol = [_handicap valueForKey:[NSString stringWithFormat:@"_SellVol%d",i+1]];
            float volFloat= [vol floatValue];
            if (_isStock) {
                volFloat = volFloat/100;
            }
            
            if (volFloat>=10000) {
                sellvolLabel.string = [NSString stringWithFormat:@"%.1f万",volFloat/10000];
            }else{
                sellvolLabel.string = [NSString stringWithFormat:@"%.0f",volFloat];
            }
            sellvolLabel.contentsScale = 2;
            sellvolLabel.foregroundColor = (Color_Bg_Black2.CGColor);
            sellvolLabel.fontSize = fontSize; //字体的大小
            sellvolLabel.alignmentMode = kCAAlignmentRight;//字体的对齐方式
            sellvolLabel.frame =CGRectMake(perWidth*6.5, (i*(-1)+4)*perHeight + (perHeight/2)-(fontHight/2), perWidth*3.5-3, fontHight);
        
            [sellhandlayer addSublayer:sellvolLabel];
            [handicaplines addObject:sellvolLabel];
        }
        //绘制买5档
        for (int i=0; i<5; ++i) {
            CATextLayer *buyLabel = [CATextLayer layer];
            buyLabel.string = [NSString stringWithFormat:@"买%d",i+1];
            buyLabel.contentsScale = 2;
            buyLabel.foregroundColor = [Color_Bg_Black1 CGColor];
            buyLabel.fontSize = fontSize; //字体的大小
            buyLabel.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
            buyLabel.frame =CGRectMake(6, i*perHeight + (perHeight/2)-(fontHight/2), perWidth*3-6, fontHight);
            
            [buyhandlayer addSublayer:buyLabel];
            [handicaplines addObject:buyLabel];
            
            CATextLayer *buypriceLabel = [CATextLayer layer];
            NSString *price = [_handicap valueForKey:[NSString stringWithFormat:@"_Buy%d",i+1]];
            buypriceLabel.string = [NSString stringWithFormat:@"%.2f",[price floatValue]];
            buypriceLabel.contentsScale = 2;
            if([price floatValue]==0){
                buypriceLabel.foregroundColor = (Color_Bg_GrayFont.CGColor);
                buypriceLabel.string = @"——";
            }else if ([price floatValue] < [_handicap.YClose floatValue]) {
                buypriceLabel.foregroundColor = (Color_Down_Green.CGColor);
            }else{
                buypriceLabel.foregroundColor = (Color_Up_Red.CGColor);
                
            }
            buypriceLabel.fontSize = fontSize; //字体的大小
            buypriceLabel.alignmentMode = kCAAlignmentRight;//字体的对齐方式
            buypriceLabel.frame =CGRectMake(perWidth*3, i*perHeight + (perHeight/2)-(fontHight/2), perWidth*3.8, fontHight);
            [buyhandlayer addSublayer:buypriceLabel];
            [handicaplines addObject:buypriceLabel];
            
            CATextLayer *buyvolLabel = [CATextLayer layer];
            NSString *vol = [_handicap valueForKey:[NSString stringWithFormat:@"_BuyVol%d",i+1]];
            
            float volFloat =[vol floatValue];
            if (_isStock) {
                volFloat = volFloat/100;
            }
            
            if (volFloat>=10000) {
                buyvolLabel.string = [NSString stringWithFormat:@"%.1f万",volFloat/10000];
            }else{
                buyvolLabel.string = [NSString stringWithFormat:@"%.0f",volFloat];
            }
            buyvolLabel.contentsScale = 2;
            buyvolLabel.foregroundColor = (Color_Bg_Black2.CGColor);
            buyvolLabel.fontSize = fontSize; //字体的大小
            buyvolLabel.alignmentMode = kCAAlignmentRight;//字体的对齐方式
            buyvolLabel.frame =CGRectMake(perWidth*6.5, i*perHeight + (perHeight/2)-(fontHight/2), perWidth*3.5-3, fontHight);
            [buyhandlayer addSublayer:buyvolLabel];
            [handicaplines addObject:buyvolLabel];
        }

    }
}

/**
 绘制成交量
 */
-(void)drawVol{
    //清除基准线
    for (int i = 0;i<vollines.count;++i) {
        CALayer* layer = (CALayer*)vollines[i];
        [layer removeFromSuperlayer];
        //        [dashlines removeObject:layer];
        
    }
    [vollines removeAllObjects];
    
    if (_isHistogram && _vols) {
        mainlayer.hidden = NO;
        rectlayer = [CALayer layer];
        rectlayer.frame = vollayer.bounds;
        
        float max=0;
        for (int i=0; i<_vols.count; ++i) {
            NSArray * arr = (NSArray*)_vols[i];//第一个是价格 第二个是成交量
            //      float vol = ([arr[1] floatValue]<0 || [arr[1] floatValue]  > 1000000)?0:[arr[1] floatValue];
            float vol = ([arr[1] floatValue]<0)?0:[arr[1] floatValue];
            max = max<vol?vol:max;
        }
        
        float ph = max>0?(vollayer.frame.size.height-3)/max:0;
        float pw = (vollayer.frame.size.width)/minutes;
        
        for (int i=0; i<_vols.count; ++i) {
            NSArray * arr = (NSArray*)_vols[i];//第一个是价格 第二个是成交量
            CAShapeLayer *volvaluelayer = [CAShapeLayer layer];
            volvaluelayer.backgroundColor = Color_Bg_Gray.CGColor;
            
            //        volvaluelayer.backgroundColor = [arr[0] floatValue]>=_close?Color_Up_Red.CGColor:Color_Down_Green.CGColor;
            //        float vol = ([arr[1] floatValue]<0 || [arr[1] floatValue]  > 1000000)?0:[arr[1] floatValue];
            float vol = ([arr[1] floatValue]<0)?0:[arr[1] floatValue];
            volvaluelayer.frame = CGRectMake(pw*i,vollayer.frame.size.height - ph*vol,1,ph*vol);
            [vollines addObject:volvaluelayer];
            [rectlayer addSublayer:volvaluelayer];
        }
        rectlayer.masksToBounds = YES;
        rectlayer.position =  CGPointMake(0,rectlayer.position.y);
        rectlayer.anchorPoint = CGPointMake(0,rectlayer.anchorPoint.y);
        [vollines addObject:rectlayer];
        [vollayer addSublayer:rectlayer];
        
        
        //初次进入的动画效果
        CGRect rect = vollayer.bounds;
        rect.size.width = 0;
        if (_vols.count>0 && isFirstVol) {
            isFirstVol = NO;
            rectlayer.frame = rect;
            [self performSelector:@selector(left2rightVol) withObject:nil afterDelay:1.f];
        }
        
        //画中线
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0,0)];
        [path addLineToPoint:CGPointMake(vollayer.frame.size.width,0) ];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, vollayer.frame.size.height/2, vollayer.frame.size.width, 1);
        
        CATextLayer* volvaluelayer = [CATextLayer layer];
        
        float maxFloat = max;
        if (_isStock) {
            maxFloat = maxFloat/100;
        }
        
        if (maxFloat > 10000) {
            volvaluelayer.string = [NSString stringWithFormat:@"%.2f万",maxFloat/10000];
        }else{
            volvaluelayer.string = [NSString stringWithFormat:@"%.0f",maxFloat];
        }
        
        volvaluelayer.foregroundColor = [[UIColor grayColor] CGColor];
        
        volvaluelayer.contentsScale = 2;
        volvaluelayer.fontSize = 10.f; //字体的大小
        volvaluelayer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
        volvaluelayer.frame =CGRectMake(5, 5, 100, 14);
        
        [vollines addObject:shapeLayer];
        [vollines addObject:volvaluelayer];
        
        [vollayer addSublayer:shapeLayer];
        [vollayer addSublayer:volvaluelayer];
    }
    
    
}

/**
 绘制虚线
 */
-(void)drawHLine:(CGPoint)origin width:(CGFloat)w price:(float)price percent:(float)per isDash:(BOOL)isdash{
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(w,0) ];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(origin.x, origin.y, w, 1);

    
    CATextLayer* pricelayer = [CATextLayer layer];
    pricelayer.string = [NSString stringWithFormat:([NSString stringWithFormat:@"%%.%@f",self.jingdu]),price];
    if(per==0){
        pricelayer.foregroundColor = [[UIColor grayColor] CGColor];
    }else if(per>0){
        pricelayer.foregroundColor = Color_Up_Red.CGColor;
    }else{
        pricelayer.foregroundColor = Color_Down_Green.CGColor;
    }

    pricelayer.contentsScale = 2;
    pricelayer.fontSize = 10.f; //字体的大小
    pricelayer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
   
    
    CATextLayer* percentlayer = [CATextLayer layer];
    
    if(per==0){
        percentlayer.string = [NSString stringWithFormat:@"%.2f%%",per];
        percentlayer.foregroundColor = [[UIColor grayColor] CGColor];
    }else if(per>0){
        percentlayer.string = [NSString stringWithFormat:@"+%.2f%%",per];
        percentlayer.foregroundColor = Color_Up_Red.CGColor;
    }else{
        percentlayer.string = [NSString stringWithFormat:@"%.2f%%",per];
        percentlayer.foregroundColor = Color_Down_Green.CGColor;
    }
    
    
    if(origin.y-14 < 0){
        pricelayer.frame =CGRectMake(origin.x+5, origin.y+5, 80, 14);
        percentlayer.frame = CGRectMake(w-105, origin.y+5 , 100, 14);
    }else if(origin.y+14 > chartlayer.frame.size.height){
        pricelayer.frame =CGRectMake(origin.x+5, origin.y-14 , 80, 14);
        percentlayer.frame = CGRectMake(w-105, origin.y-14 , 100, 14);
    }else{
        pricelayer.frame =CGRectMake(origin.x+5, origin.y-7 , 80, 14);
        percentlayer.frame = CGRectMake(w-105, origin.y-7 , 100, 14);
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
        [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
        // 3.0f设置虚线的宽度 [shapeLayer setLineWidth:1.0f];
        [shapeLayer setLineJoin:kCALineJoinRound];
        if (isdash) {
            // 1=线的宽度 1=每条线的间距
            [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],nil]];
        }
        
        shapeLayer.path = path.CGPath;
    }

    percentlayer.contentsScale = 2;
    percentlayer.fontSize = 10.f; //字体的大小
    percentlayer.alignmentMode = kCAAlignmentRight;//字体的对齐方式
    
    [pricelines addObject:pricelayer];
    [pricelines addObject:percentlayer];
    [pricelines addObject:shapeLayer];

    [chartlayer addSublayer:shapeLayer];
    [chartlayer addSublayer:pricelayer];
    [chartlayer addSublayer:percentlayer];
    
}

/**
 绘制虚线
 */
-(void)drawVLine:(CGPoint)origin isDash:(BOOL)isdash{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(0,chartlayer.frame.size.height) ];
    CAShapeLayer *shapeChartLayer = [CAShapeLayer layer];
    shapeChartLayer.frame = CGRectMake(origin.x, 0 , 1, chartlayer.frame.size.height);
    [shapeChartLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeChartLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
        // 3.0f设置虚线的宽度 [shapeLayer setLineWidth:1.0f];
    [shapeChartLayer setLineJoin:kCALineJoinRound];
    if (isdash) {
        // 1=线的宽度 1=每条线的间距
        [shapeChartLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],nil]];
    }
        
    shapeChartLayer.path = path.CGPath;
    
    [pricelines addObject:shapeChartLayer];
    
    [chartlayer addSublayer:shapeChartLayer];
    
    path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,0)];
    [path addLineToPoint:CGPointMake(0,vollayer.frame.size.height) ];
    CAShapeLayer *shapeVolLayer = [CAShapeLayer layer];
    shapeVolLayer.frame = CGRectMake(origin.x, 0 , 1, vollayer.frame.size.height);
    [shapeVolLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeVolLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
    // 3.0f设置虚线的宽度 [shapeLayer setLineWidth:1.0f];
    [shapeVolLayer setLineJoin:kCALineJoinRound];
    if (isdash) {
        // 1=线的宽度 1=每条线的间距
        [shapeVolLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:3],[NSNumber numberWithInt:3],nil]];
    }
    
    shapeVolLayer.path = path.CGPath;
    
    [pricelines addObject:shapeVolLayer];
    
    [vollayer addSublayer:shapeVolLayer];

}


-(void)drawTime:(CGPoint)origin width:(CGFloat)w date:(NSDate*)date{
    CATextLayer* timelayer = [CATextLayer layer];
    
    if (origin.x<=0) {
        timelayer.frame =CGRectMake(origin.x, 1 , w, 14);
        timelayer.alignmentMode = kCAAlignmentLeft;//字体的对齐方式
    }else if (origin.x>=xlabellayer.frame.size.width) {
        timelayer.frame =CGRectMake(origin.x-w, 1 , w, 14);
        timelayer.alignmentMode = kCAAlignmentRight;//字体的对齐方式
    }else{
        timelayer.frame =CGRectMake(origin.x-w/2, 1 , w, 14);
        timelayer.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"HH:mm"];
    timelayer.string = [dateFormatter stringFromDate:date];
    timelayer.foregroundColor = [[UIColor grayColor] CGColor];
    timelayer.contentsScale = 2;
    timelayer.fontSize = 10.f; //字体的大小
    
    
    [pricelines addObject:timelayer];
    
    [xlabellayer addSublayer:timelayer];

}



-(void)drawChartWithPrices:(NSArray*)prices
                    yClose:(NSString*)close
                 highPrice:(NSString*)high
                  lowPrice:(NSString*)low
                 openPrice:(NSString*)open
                      time:(NSString*)time
                 animation:(BOOL)needAnimation
                allMinutes:(int)min
                spliteTime:(NSArray*) sptime
               splitDiffer:(NSArray*) spdiffer{
    if (_isLine) {
        _close = [close floatValue];
        _high = [high floatValue];
        _low = [low floatValue];
        _open = [open floatValue];
        _time = time;
        _prices = prices;
        minutes = min;
        splittime = sptime;
        splitdiffer = spdiffer;
        
        if (!needAnimation) {
            isFirstPrice = needAnimation;
        }
        
        [CATransaction begin];
        ///关闭隐式动画
        [CATransaction setDisableActions:YES];
        [self drawPrice];
        
        [CATransaction commit];
    }
}

-(void)drawFreeStyleChartWithPrices:(NSArray*)prices
                             yClose:(NSString*)close
                          highPrice:(NSString*)high
                           lowPrice:(NSString*)low
                          openPrice:(NSString*)open
                               time:(NSString*)time
                          animation:(BOOL)needAnimation
                         allMinutes:(int)min
                         spliteTime:(NSArray*) sptime
                        splitDiffer:(NSArray*) spdiffer{
    if (_isLine) {
        _close = [close floatValue];
        _high = [high floatValue];
        _low = [low floatValue];
        _open = [open floatValue];
        _time = time;
        _prices = prices;
        minutes = min;
        splittime = sptime;
        splitdiffer = spdiffer;
        
        if (!needAnimation) {
            isFirstPrice = needAnimation;
        }
        
        [CATransaction begin];
        ///关闭隐式动画
        [CATransaction setDisableActions:YES];
        [self drawFreeStylePrice];
        
        [CATransaction commit];
    }
}

-(void)drawChartWithVols:(NSArray*)vols
               animation:(BOOL)needAnimation
                   stock:(BOOL)isStock
              allMinutes:(int)min
              spliteTime:(NSArray*) sptime
             splitDiffer:(NSArray*) spdiffer{
    if(_isHistogram){
        _vols = vols;
        minutes = min;
        splittime = sptime;
        splitdiffer = spdiffer;
        if (!needAnimation) {
            isFirstVol = needAnimation;
        }
        _isStock = isStock;
        
        [CATransaction begin];
        ///关闭隐式动画
        [CATransaction setDisableActions:YES];
        [self drawVol];
        [CATransaction commit];
    }
}

-(void)drawChartWithHandicap:(ProductPanKouEntity*)handicap{
    if (_isHandicap) {
        _handicap = handicap;
        [CATransaction begin];
        
        ///关闭隐式动画
        [CATransaction setDisableActions:YES];
        [self drawHandicap];
        [CATransaction commit];
    }
    
}


-(void) showCycle{
    cycle.hidden=NO;
}

-(void)changeCycle{
    times++;
    times = times%2;
    if (times == 1) {
        cycle.affineTransform = CGAffineTransformMakeScale(1.3f,1.3f);
        //lay.frame = CGRectMake(100, 100, lay.frame.size.width+5, lay.frame.size.width+5);
    }else{
        cycle.affineTransform = CGAffineTransformMakeScale(1.f,1.f);
        //lay.frame = CGRectMake(100, 100, lay.frame.size.width-5, lay.frame.size.width-5);
    }
}

-(void)startPulse{//开启最新价跳动
    times ++;
    [self showCycle];
    if (timer==nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:.5f target:self selector:@selector(changeCycle) userInfo:nil repeats:YES];
    }
    
}
-(void)endPulse{//关闭最新价跳动
    cycle.hidden = YES;
    times = -1;
    if (timer!=nil) {
        [timer invalidate];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc{
    DDLogInfo(@"%@ has dealloc",[self class]);
}

@end
