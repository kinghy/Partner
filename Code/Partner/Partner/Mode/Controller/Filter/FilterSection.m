//
//  FilterSection.m
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "FilterSection.h"

@implementation FilterSection

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)loadBtnArray:(NSArray*)array{
    self.btnArray = [NSArray arrayWithArray:array];
    for (FilterButton* btn in self.btnArray) {
        [btn addTarget:self action:@selector(btnChanged:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)btnChanged:(FilterButton*)btn{
    for (FilterButton* filterbtn in self.btnArray) {
        if (filterbtn!=btn) {
            filterbtn.isChosed = NO;
        }
    }
}

-(void)resetAllBtn{
    for (FilterButton* filterbtn in self.btnArray) {
        filterbtn.isChosed = NO;
    }
}
@end

@implementation FilterMarketSection
-(void)awakeFromNib{
    [self loadBtnArray:@[self.stockBtn,self.hkBtn,self.metalBtn]];
}
@end

@implementation FilterLimitSection
-(void)awakeFromNib{
    [self loadBtnArray:@[self.limit3Btn,self.limit5Btn,self.limit7Btn,self.limit10Btn]];
}
@end

@implementation FilterButton
-(void)awakeFromNib{
    self.isChosed = NO;
    [self addTarget:self action:@selector(btnChoosed) forControlEvents:UIControlEventTouchUpInside];
}

-(void)btnChoosed{
    self.enabled = NO;
    self.layer.borderColor = kColorFilterChosedBtnBorder.CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 3;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.backgroundColor = kColorFilterChoserBtnBG;
}

-(void)btnUnChoosed{
    self.enabled = YES;
    self.layer.borderColor = Color_Confirm_Gray.CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 3;
    [self setTitleColor:Color_Bg_Black1 forState:UIControlStateNormal];
    self.backgroundColor = [UIColor whiteColor];
}

-(BOOL)isChosed{
    return !self.enabled;
}

-(void)setIsChosed:(BOOL)isChosed{
    if (isChosed) {
        [self btnChoosed];
    }else{
        [self btnUnChoosed];
    }
}

@end


@implementation FilterAllocationSection
-(void)awakeFromNib{
    [self loadBtnArray:@[self.allo70Btn,self.allo80Btn,self.allo90Btn,self.alloAllBtn]];
}

@end

@implementation FilterRateSection : FilterSection
-(void)awakeFromNib{
    [self loadBtnArray:@[self.rate15Btn,self.rate30Btn,self.rate40Btn,self.rate50Btn]];
}
@end

@implementation FilterResetSection
-(void)awakeFromNib{
    self.reset.layer.borderColor = kColorFilterChosedBtnBorder.CGColor;
    self.reset.layer.borderWidth = 1.f;
    self.reset.layer.cornerRadius = 3;
    [self.reset setTitleColor:kColorFilterChosedBtnBorder forState:UIControlStateNormal];
}
@end

@implementation FilterMoneySection
-(void)awakeFromNib{
    [self loadBtnArray:@[self.money100Btn,self.money11to20Btn,self.money1to10Btn,self.money21to30Btn,self.money31to40Btn,self.money41to50Btn,self.money51to100Btn]];
}

-(void)resetAllBtn{
    [super resetAllBtn];
    self.startTextField.text = @"";
    self.endTextField.text = @"";
}
@end