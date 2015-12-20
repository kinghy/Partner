//
//  AppUtil.h
//  QianFangGuJie
//
//  Created by  rjt on 15/9/14.
//  Copyright © 2015年 JYZD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUtil : NSObject
+(UIColor*)colorWithOpen:(float)open andNew:(float)now;//根据价格差返回颜色

+(void)gotoIndex:(BOOL)animated;

+(void)controller:(UIViewController*)controller go2Controller:(Class)cls animated:(BOOL)animated;

@end
