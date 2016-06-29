//
//  EFTableView.h
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EFTableView;

@protocol EFTableViewDelegate <NSObject>
@optional

-(void)willLayoutSubviewsInTableView:(EFTableView*)tableView;

@end

@interface EFTableView : UITableView
@property (nonatomic,weak) id<EFTableViewDelegate> efDelegate;
@end



