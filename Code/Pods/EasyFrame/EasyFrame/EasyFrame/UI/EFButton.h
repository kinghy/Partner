//
//  EFButton.h
//  Partner
//
//  Created by kinghy on 15/10/2.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFButton : UIButton{
    UIColor* unselectedBackgroundColor;
}

/**
 *  设置按钮选中后的变色
 */
@property (strong,nonatomic) UIColor* selectedBackgroundColor;

@end
