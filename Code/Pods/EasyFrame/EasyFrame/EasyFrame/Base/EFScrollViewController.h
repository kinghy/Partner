//
//  EFScrollViewController.h
//  Partner
//
//  Created by  rjt on 15/11/30.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFBaseViewController.h"

@interface EFScrollViewController : EFBaseViewController
/*!
 *  @brief  子类必须拥有一个ScrollView的实例
 */
@property (weak, nonatomic) IBOutlet UIScrollView *pScrollView;

/*!
 *  @brief  子类必须能生成一个EFSection实例
 */
@property (strong, nonatomic) EFSection *pSection;

/*!
 *  @brief  填充满父窗口开关
 */
@property (nonatomic) BOOL fillParentEnabled;


/*!
 *  @brief  初始化section
 *
 *  @return 返回一个section实例
 */
-(EFSection*)loadSection;

@end
