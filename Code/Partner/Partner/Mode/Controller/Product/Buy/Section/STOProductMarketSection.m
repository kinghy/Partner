//
//  STOProductMarketSection.m
//  Partner
//
//  Created by  rjt on 15/10/27.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOProductMarketSection.h"
#import "STOProductGraphViewController.h"

@implementation STOProductMarketSection

-(void)awakeFromNib
{
    self.graphicController = [[STOProductGraphViewController alloc] initWithNibName:@"STOProductGraphViewController" bundle:nil];
    self.graphicController.stockCode = self.stockCode;
    [self.placeholderView addSubview:self.graphicController.view];
    self.graphicController.needAnimation = NO;
    //    [self fillParent];
}


@end
