//
//  ProductGraphViewController.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/2/1.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "ProductGraphViewController.h"
#import "WHTimerManager.h"
#import "WHOnceTask.h"
#import "ChartView.h"
#import "KChartView.h"
#import "ProductVolChartEntity.h"
#import "ProductChartEntity.h"
#import "ProductKChartEntity.h"

@interface ProductGraphViewController ()
@property (strong,nonatomic) UIView * lineView;
@property (strong,nonatomic) NSMutableArray * graphies;
@property (strong,nonatomic) NSMutableArray * btns;
@property (strong,nonatomic) UISwipeGestureRecognizer * leftSwipeGestureRecognizer;
@property (strong,nonatomic) UISwipeGestureRecognizer * rightSwipeGestureRecognizer;
@end

@implementation ProductGraphViewController



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self clickBtnDisplayGraph:_chartBtn];
    [self refreshChart];
}

-(void)refreshChart{
    if (![[WHTimerManager shareTimerManager] hasNotifyName:kGraphTime]) {
        [[WHTimerManager shareTimerManager] addTarget:self selector:@selector(refreshGraphDataSource) notifyName:kGraphTime];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.kchart.hidden = YES;
    CGRect rect = [UIScreen mainScreen].bounds;
    [self.chooseBarView setFrame:CGRectMake(self.chooseBarView.frame.origin.x, self.chooseBarView.frame.origin.y, self.chooseBarView.frame.size.width*rect.size.width/375, self.chooseBarView.frame.size.height)];
    
    self.needAnimation = YES;//默认需要动画
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = Color_Bg_Text_Chosed_Blue;
    [self.chooseBarView addSubview:self.lineView];
    //网络监测
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeNetWork:) name:kReachabilityChangedNotification object:nil];
//    reachability = [Reachability reachabilityForInternetConnection];
//    [reachability startNotifier];
//    NetworkStatus status = reachability.currentReachabilityStatus;
    self.graphies = [[NSMutableArray alloc] init];
    self.btns = [[NSMutableArray alloc] init];
    if (self.chartView) {
        [self.graphies addObject:self.chartView];
        [self.btns addObject:self.chartBtn];
    }
    if (self.partChartView) {
        [self.graphies addObject:self.partChartView];
        [self.btns addObject:self.partChartBtn];
    }
    if (self.kchart) {
        [self.graphies addObject:self.kchart];
        [self.btns addObject:self.kChartBtn];
    }
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    

}

//-(void)changeNetWork:(NSNotification *)notification{
//    [WpCommonFunction showNotifyHUDAtViewBottom:self.navigationController.view withErrorMessage:@"网络环境改变，请检查网络"];
//
//}
#pragma mark - 滑动事件
-(void)handleSwipes:(UISwipeGestureRecognizer *)sender{
    NSInteger now=0;
    while (now<self.graphies.count) {
        if (![self.graphies[now] isHidden]) {
            break;
        }
        ++now;
    }
    NSInteger target = 0;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        target = now+1;
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        target = now-1;
    }
    
    if (target < 0 ){
        target = self.graphies.count-1;
    }else if(target >= self.graphies.count ){
        target = 0;
    }
    
    UIView * tv = self.graphies[target];
    UIView * nv = self.graphies[now];
    
    UIButton *tb = self.btns[target];
    UIButton *nb = self.btns[now];
    
    nv.hidden = YES;
    tv.hidden = NO;
    [tb setTitleColor:Color_Bg_Text_Chosed_Blue forState:UIControlStateNormal];
    [nb setTitleColor:Color_Bg_Text_UnChosed_Blue forState:UIControlStateNormal];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3f];
    self.lineView.frame = CGRectMake(tb.frame.origin.x, tb.frame.size.height-1.5, tb.frame.size.width, 1.5);
    [UIView commitAnimations];

    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = .3f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        animation.subtype = kCATransitionFromLeft;
    }else{
        animation.subtype = kCATransitionFromRight;
    }
    
    [[tv layer] addAnimation:animation forKey:@"animation"];
        
}

#pragma mark - 按钮点击事件
- (IBAction)clickBtnDisplayGraph:(UIButton *)btn {

    for (int i=0; i<self.btns.count; ++i) {
        UIButton *b = self.btns[i];
        UIView *v = self.graphies[i];
        if (b == btn) {
            [b setTitleColor:Color_Bg_Text_Chosed_Blue forState:UIControlStateNormal];
            v.hidden = NO;
            //首尾式动画
            [UIView beginAnimations:nil context:nil];
            //执行动画
            //设置动画执行时间
            [UIView setAnimationDuration:0.3f];
            self.lineView.frame = CGRectMake(b.frame.origin.x, b.frame.size.height-1.5, b.frame.size.width, 1.5);
            [UIView commitAnimations];
        }else{
            [b setTitleColor:Color_Bg_Text_UnChosed_Blue forState:UIControlStateNormal];
            v.hidden = YES;
        }
    }
    
}


-(void)getChart{
    DEFINED_WEAK_SELF
    [self.manager refreshChart:^(EFEntity* entity,NSError *error) {
        if (error==nil) {
            ProductChartEntity *e = (ProductChartEntity *)entity;
            [[WHGlobalHelper shareGlobalHelper] put:e key:kHqChartKey];
            [_self refreshHqChart];
        }
    }];
}

-(void)getVolChart{
    DEFINED_WEAK_SELF
    [self.manager refreshVolChart:^(EFEntity* entity,NSError *error) {
        if (error==nil){
            ProductVolChartEntity *e = (ProductVolChartEntity *)entity;
            [[WHGlobalHelper shareGlobalHelper] put:e key:kHqVolChartKey];
            [_self refreshVolChart];
        }
    }];
}

-(void)getPankou{
    DEFINED_WEAK_SELF
    [self.manager refreshPankou:^(EFEntity* entity,NSError *error) {
        if (error==nil){
            ProductPanKouEntity *e = (ProductPanKouEntity *)entity;
#warning 注释检查股票停牌
//            [_self checkIsSuspended:e];
            [[WHGlobalHelper shareGlobalHelper]put:e key:kPankouKey];
            [_self refreshPankou];
        }
    }];

}

-(void)getKChart{
    DEFINED_WEAK_SELF
    [self.manager refreshKChart:^(EFEntity* entity,NSError *error) {
        if (error==nil) {
            ProductKChartEntity *e = (ProductKChartEntity*)entity;
            [[WHGlobalHelper shareGlobalHelper] put:e key:kHqKChartKey];
            [_self refreshKchart];
        }
    }];
}

- (void)refreshGraphDataSource {
    //分时图
    if ([[WHOnceTask shareOnceTask]expired:kHqChartKey validTime:kHqChartValue]) {
        [self getChart];
        [self getVolChart];
    }

    //k线图
    if ([[WHOnceTask shareOnceTask] expired:kHqKChartKey validTime:kHqKChartVal]) {
        [self getKChart];
    }
    
  //  盘口
    if (!_isPankou) {
        if ([[WHOnceTask shareOnceTask] expired:kPankouKey validTime:kPankouVal]) {
            [self getPankou];
        }
    }
    
    
}

#warning 注释检查股票停牌
//- (void)checkIsSuspended:(ProductPanKouEntity *)e {
//    
////    if ( [e.volume integerValue] == 0) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kStockSuspended object:[e.volume integerValue]?@0:@1] ;
////    }
//}


-(void)refreshPankou {
    ProductPanKouEntity *e = [[WHGlobalHelper shareGlobalHelper]get:kPankouKey];
    
    [self.chartView drawChartWithHandicap:e];
}

-(void)refreshVolChart{

}




#pragma mark - 格式化小数 四舍五入
- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[WHTimerManager shareTimerManager] removeTarget:self notifyName:kGraphTime];
    [[WHOnceTask shareOnceTask] removeTask:kHqChartKey];
    [[WHOnceTask shareOnceTask] removeTask:kHqKChartKey];
    [[WHOnceTask shareOnceTask] removeTask:kPankouKey];
    
}


- (void)dealloc {
    [self.chartView endPulse];
    
//    [[WHTimerManager shareTimerManager] removeTarget:self notifyName:kGraphTime];
    

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHQViewNeedCodeString object:nil];
}

-(void)setJingdu:(NSString *)jd{
    self.kchart.jingdu = jd;
    self.chartView.jingdu = jd;
    self.partChartView.jingdu = jd;
}
@end
