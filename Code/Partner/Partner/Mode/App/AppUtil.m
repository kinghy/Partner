//
//  AppUtil.m
//  QianFangGuJie
//  此类中实现一些工具方法
//  Created by  rjt on 15/9/14.
//  Copyright © 2015年 JYZD. All rights reserved.
//

#import "AppUtil.h"
#import "AppDelegate.h"
#import "IndexViewController.h"

@implementation AppUtil
+(UIColor*)colorWithOpen:(float)open andNew:(float)now{
    if (open > now) {
        return Color_Down_Green;
    }else if(now>open){
        return Color_Up_Red;
    }else{
        return Color_DS_Gray;
    }
}

+(void)gotoIndex:(BOOL)animated{
    [self controller:kShareAppDelegate.nav.topViewController go2Controller:[IndexViewController class] animated:YES];
}

+(void)controller:(UIViewController*)controller go2Controller:(Class)cls animated:(BOOL)animated{
    for(UIViewController* ctrl in controller.navigationController.childViewControllers){
        if ([ctrl isMemberOfClass:cls]) {
            [controller.navigationController popToViewController:ctrl animated:animated];
            break;
        }
    }
}

@end
