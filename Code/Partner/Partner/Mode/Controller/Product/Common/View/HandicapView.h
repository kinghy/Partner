//
//  HandicapView.h
//  QianFangGuJie
//
//  Created by tongshangren on 15/9/7.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HandicapView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnClose;

@property (weak, nonatomic) IBOutlet UILabel *open;
@property (weak, nonatomic) IBOutlet UILabel *high;
@property (weak, nonatomic) IBOutlet UILabel *price_max;
@property (weak, nonatomic) IBOutlet UILabel *transactionRate;
@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *yClose;
@property (weak, nonatomic) IBOutlet UILabel *low;
@property (weak, nonatomic) IBOutlet UILabel *price_min;
@property (weak, nonatomic) IBOutlet UILabel *transactionDif;
@property (weak, nonatomic) IBOutlet UILabel *volume;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

-(void)fixColor;
@property (weak, nonatomic) IBOutlet UIView *infoView;

@end
