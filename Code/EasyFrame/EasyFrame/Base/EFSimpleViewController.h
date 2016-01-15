//
//  EFSimpleViewController.h
//  EasyFrame
//
//  Created by  rjt on 16/1/13.
//  Copyright © 2016年 Kinghy. All rights reserved.
//

#import "EFBaseViewController.h"
#import "EFAdaptor.h"
/*!
 *  @brief 简单视图控制器的基类，继承此基类的子类不应该使用任何EFBll
 */
@interface EFSimpleViewController : EFBaseViewController<EFAdaptorDelegate>
@property(nonatomic,strong) EFAdaptor* pAdaptor;
@property (weak, nonatomic) IBOutlet EFTableView *pTable;
/*!
 *  @brief 初始化Adaptor,子类实现
 */
-(void)initAdaptor;
@end
