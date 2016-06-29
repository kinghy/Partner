//
//  STOProductBuyOrderSection.m
//  Partner
//
//  Created by  rjt on 15/10/28.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductBuyOrderSection.h"

@implementation STOProductBuyOrderSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end

@implementation STOProductContractsSection

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

@implementation STOProductContractsHeaderSection

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

@implementation STOProductContractsListSection

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

@implementation STOProductBuyOrderPriceSection

@end

@implementation STOProductBuyOrderHandicapSection

@end

@implementation STOProductBuyOrderContractSection

@end

@implementation STOProductBuyOrderSplitSection

@end

#define kDashboardShortLine 7
#define kDashboardLongLine 12

@implementation STOProductBuyOrderDashboardSection

-(void)sectionDidLoad{
    self.max = 500000;
    self.min = 10000;
    self.per = 1000;
    self.perWidth = 10;
    self.scrollView.delegate = self;
    self.scrollView.decelerationRate = 0;//滑动率0
    
    [self refreshBoard];
    
    //监视最大值或者最小值的变动
    @weakify(self)
    [[RACSignal combineLatest:@[RACObserve(self, min),RACObserve(self, max)]] subscribeNext:^(id x) {
        @strongify(self)
        [self refreshBoard];
    }];

}

-(void)refreshBoard{
    [_choseView removeFromSuperview];
    int width = (self.max - self.min)/self.per;
    _choseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,width*self.perWidth+self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    
    for (int i=0; self.min + i*self.per <= self.max ; i++) {
        CALayer *layer = [CALayer layer];
        CATextLayer *textLayer = nil;
        if (i%10 == 0) {
            layer.backgroundColor = [UIColor blackColor].CGColor;
            layer.frame = CGRectMake(self.perWidth*i, self.scrollView.bounds.size.height-kDashboardLongLine, 1, kDashboardLongLine);
            textLayer = [CATextLayer layer];
            textLayer.frame = CGRectMake(0,0, 50, 12);
            textLayer.alignmentMode = @"center";
            textLayer.position = CGPointMake(self.perWidth*i,  self.scrollView.bounds.size.height-kDashboardLongLine-15);
            textLayer.fontSize = 12;
            textLayer.foregroundColor =Color_Bg_Black1.CGColor;//字体的颜色
            
            textLayer.string = [NSString stringWithFormat:@"%d",self.min + i*self.per];
            
        }else{
            layer.backgroundColor = [UIColor grayColor].CGColor;
            layer.frame = CGRectMake(self.perWidth*i, self.scrollView.bounds.size.height-kDashboardShortLine, 1, kDashboardShortLine);
        }
        [_choseView.layer addSublayer:layer];
        [_choseView.layer addSublayer:textLayer];
    }
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    

    [self.scrollView addSubview:_choseView];

    [self adjustView];
    [self adjustChosed];
}

-(void)layoutSubviews{
    [self adjustView];
}

-(void)adjustView{
//    if ( _viewWidth != _scrollView.frame.size.width) {
        _viewWidth = _scrollView.frame.size.width;
        int width = (self.max - self.min)/self.per;
        _scrollView.contentSize = CGSizeMake(width*self.perWidth+_viewWidth, self.scrollView.bounds.size.height);
        CGRect rect = self.choseView.frame;
        rect.origin.x = _targetView.frame.origin.x;
        self.choseView.frame = rect;
//    }
}

#pragma UIScrollView - delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger num =[[ NSString stringWithFormat:@"%.f", self.scrollView.contentOffset.x/self.perWidth] integerValue];
    _money.text  = [NSString stringWithFormat:@"%ld",_min + num * _per];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {//没有惯性滑动就调用
        [self adjustChosed];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self adjustChosed];
}

-(void)adjustChosed{
    NSInteger num =[[ NSString stringWithFormat:@"%.f", self.scrollView.contentOffset.x/self.perWidth] integerValue];
    [self.scrollView setContentOffset:CGPointMake(num*self.perWidth, self.scrollView.contentOffset.y) animated:YES];
}


@end
