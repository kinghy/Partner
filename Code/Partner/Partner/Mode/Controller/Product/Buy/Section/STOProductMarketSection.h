//
//  STOProductMarketSection.h
//  Partner
//
//  Created by  rjt on 15/10/27.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@class ProductGraphViewController;

@interface STOProductMarketSection : EFSection

@property (nonatomic,strong) ProductGraphViewController *graphicController;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;
@property (weak, nonatomic) IBOutlet UIView *confirmView;
@property (nonatomic,copy)NSString *stockCode;
@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (weak, nonatomic) IBOutlet UIButton *disableBtn;
/**背景色*/
@property (weak, nonatomic) IBOutlet UIView *viewColor;
@property (weak, nonatomic) IBOutlet UILabel *stockNameLab;
@property (weak, nonatomic) IBOutlet UILabel *stockCodeLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPrice;
@property (weak, nonatomic) IBOutlet UILabel *rhythmLab;
@property (weak, nonatomic) IBOutlet UILabel *percentLab;
@property (weak, nonatomic) IBOutlet UIView *profitView;
@property (weak, nonatomic) IBOutlet UIView *sellView;

@property (weak, nonatomic) IBOutlet UILabel *openLab;
@property (weak, nonatomic) IBOutlet UILabel *closeLab;
@property (weak, nonatomic) IBOutlet UILabel *highestLab;
@property (weak, nonatomic) IBOutlet UILabel *lowestLab;

@property (weak, nonatomic) IBOutlet UILabel *stopLab;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnDetailInfo;
@end
