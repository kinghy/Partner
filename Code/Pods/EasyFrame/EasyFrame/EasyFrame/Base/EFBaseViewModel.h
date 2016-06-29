//
//  EFBaseViewModel.h
//  EasyFrame
//  MVVM模式中的ViewModel基类
//  Created by  rjt on 15/12/4.
//  Copyright © 2015年 JYZD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFBaseViewModel : NSObject
/*!
 *  @brief  构建方法
 *
 *  @return ViewModel实例
 */
+(instancetype)viewModel;
/*!
 *  @brief  viewModel生成后调用
 */
-(void)viewModelDidLoad;
@end
