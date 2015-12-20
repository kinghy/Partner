//
//  HandicapView.m
//  QianFangGuJie
//
//  Created by tongshangren on 15/9/7.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import "HandicapView.h"

@implementation HandicapView





- (void)awakeFromNib {
    

    self.frame = [UIScreen mainScreen].bounds;
    
    self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    [[self.infoView layer]setCornerRadius:10.0];
    
    
    [self.btnClose addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [self.btnClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.btnClose setImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted
     ];
    
    self.open.textColor
    =self.high.textColor
    =self.transactionDif.textColor
    =self.transactionRate.textColor
    =self.amount.textColor
    =self.yClose.textColor
    =self.low.textColor
    =self.volume.textColor
    =Color_DS_Gray;
    
    self.price_max.textColor=Color_Up_Red;
    self.price_min.textColor=Color_Down_Green;
    
    UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(remove)];
    [self.backgroundView addGestureRecognizer:tapGestureRecognizer];
  
}



-(void)fixColor{
    if ([self.open.text floatValue]>[self.yClose.text floatValue]) {
        self.open.textColor=Color_Up_Red;
    }else{
        self.open.textColor=Color_Down_Green;
    }
    
    if ([self.high.text floatValue]>[self.yClose.text floatValue]) {
        self.high.textColor=Color_Up_Red;
    }else{
        self.high.textColor=Color_Down_Green;
    }

    if ([self.low.text floatValue]>[self.yClose.text floatValue]) {
        self.low.textColor=Color_Up_Red;
    }else{
        self.low.textColor=Color_Down_Green;
    }
    
   
    if ([self.transactionRate.text rangeOfString:@"-"].length) {
        self.transactionRate.textColor=Color_Down_Green;
    }else{
        self.transactionRate.textColor=Color_Up_Red;
    }
    
    if ([self.transactionDif.text floatValue]>0) {
        self.transactionDif.textColor=Color_Up_Red;
    }else{
        self.transactionDif.textColor=Color_Down_Green;
    }
    
    
    if ([self.open.text doubleValue]==0) {
        self.open.text = @"——";
        self.open.textColor = self.amount.textColor;
    }
    if ([self.high.text doubleValue]==0) {
        self.high.text = @"——";
        self.high.textColor = self.amount.textColor;
    }
    if ([self.price_max.text doubleValue]==0) {
        self.price_max.text = @"——";
        self.price_max.textColor = self.amount.textColor;
    }
    if ([self.transactionRate.text doubleValue]==0) {
        self.transactionRate.text = @"——";
        self.transactionRate.textColor = self.amount.textColor;
    }
    
    if ([self.yClose.text doubleValue]==0) {
        self.yClose.text = @"——";
        self.yClose.textColor = self.amount.textColor;
    }
    if ([self.low.text doubleValue]==0) {
        self.low.text = @"——";
        self.low.textColor = self.amount.textColor;
    }
    if ([self.price_min.text doubleValue]==0) {
        self.price_min.text = @"——";
        self.price_min.textColor = self.amount.textColor;
    }

    
    
    if ([self.volume.text doubleValue]==0) {
        self.volume.text = @"——";
        self.volume.textColor = self.amount.textColor;
    }else if ([self.volume.text doubleValue]>=100000000)
    {
        self.volume.text=[NSString stringWithFormat:@"%.2f亿手",(float)([self.volume.text doubleValue]/100000000)];
    }
    else if ([self.volume.text doubleValue]>=10000)
    {
        if([self.volume.text doubleValue]<10000000){
            self.volume.text=[NSString stringWithFormat:@"%.2f万手",(float)([self.volume.text doubleValue]/10000)];
        }else{
            self.volume.text=[NSString stringWithFormat:@"%.1f万手",(float)([self.volume.text doubleValue]/10000)];
        }

    }
    else{
        self.volume.text=[NSString stringWithFormat:@"%1.f手",[self.volume.text doubleValue]];
    }
    
    if ([self.amount.text doubleValue]==0){
        self.amount.text=@"——";
        self.amount.textColor = self.amount.textColor;
    }else if ([self.amount.text doubleValue]>=100000000)
    {
        self.amount.text=[NSString stringWithFormat:@"%.2f亿",(float)([self.amount.text doubleValue]/100000000)];
    }
    else if ([self.amount.text doubleValue]>=10000)
    {
        self.amount.text=[NSString stringWithFormat:@"%.2f万",(float)([self.amount.text doubleValue]/10000)];
    }else{
        self.amount.text=[NSString stringWithFormat:@"%1.f",(float)([self.amount.text doubleValue])];
    }

    if ([self.transactionDif.text doubleValue]==0) {
        self.transactionDif.text = @"——";
        self.transactionDif.textColor = self.amount.textColor;
    }else if ([self.transactionDif.text doubleValue]>=100000000||[self.transactionDif.text doubleValue]<=-100000000)
    {
        self.transactionDif.text=[NSString stringWithFormat:@"%.2f亿",(float)([self.transactionDif.text doubleValue]/100000000)];
    }
    else if ([self.transactionDif.text doubleValue]>=10000||[self.transactionDif.text doubleValue]<=-10000)
    {
        self.transactionDif.text=[NSString stringWithFormat:@"%.2f万",(float)([self.transactionDif.text doubleValue]/10000)];
    }else{
        self.transactionDif.text=[NSString stringWithFormat:@"%1.f",(float)([self.transactionDif.text doubleValue])];
    }
}


-(void)remove
{
    [self removeFromSuperview];
}
@end
