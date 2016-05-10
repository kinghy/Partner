//
//  FilterSection.h
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFSection.h"

@interface FilterButton : UIButton
@property (nonatomic) BOOL isChosed;

@end

@interface FilterSection : EFSection
@property (strong,nonatomic) NSString *selectedValue;//当前选择值
@property (strong,nonatomic) NSArray *btnArray;
-(void)loadBtnArray:(NSArray*)array;
-(void)btnChanged:(FilterButton*)btn;
-(void)resetAllBtn;
@end


@interface FilterMarketSection : FilterSection
@property (weak, nonatomic) IBOutlet FilterButton *stockBtn;
@property (weak, nonatomic) IBOutlet FilterButton *hkBtn;
@property (weak, nonatomic) IBOutlet FilterButton *metalBtn;


@end


@interface FilterLimitSection : FilterSection
@property (weak, nonatomic) IBOutlet FilterButton *limit3Btn;
@property (weak, nonatomic) IBOutlet FilterButton *limit5Btn;
@property (weak, nonatomic) IBOutlet FilterButton *limit7Btn;
@property (weak, nonatomic) IBOutlet FilterButton *limit10Btn;


@end

@interface FilterAllocationSection : FilterSection
@property (weak, nonatomic) IBOutlet FilterButton *allo70Btn;
@property (weak, nonatomic) IBOutlet FilterButton *allo80Btn;
@property (weak, nonatomic) IBOutlet FilterButton *allo90Btn;
@property (weak, nonatomic) IBOutlet FilterButton *alloAllBtn;


@end

@interface FilterRateSection : FilterSection
@property (weak, nonatomic) IBOutlet FilterButton *rate15Btn;
@property (weak, nonatomic) IBOutlet FilterButton *rate30Btn;
@property (weak, nonatomic) IBOutlet FilterButton *rate40Btn;
@property (weak, nonatomic) IBOutlet FilterButton *rate50Btn;

@end

@interface FilterResetSection : FilterSection
@property (weak, nonatomic) IBOutlet UIButton *reset;
@end

@interface FilterMoneySection : FilterSection
@property (weak, nonatomic) IBOutlet FilterButton *money1to10Btn;
@property (weak, nonatomic) IBOutlet FilterButton *money11to20Btn;
@property (weak, nonatomic) IBOutlet FilterButton *money21to30Btn;
@property (weak, nonatomic) IBOutlet FilterButton *money31to40Btn;
@property (weak, nonatomic) IBOutlet FilterButton *money41to50Btn;
@property (weak, nonatomic) IBOutlet FilterButton *money51to100Btn;
@property (weak, nonatomic) IBOutlet FilterButton *money100Btn;
@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@end


