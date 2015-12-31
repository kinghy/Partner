//
//  EFEmptyEntity.h
//  EasyFrame
//
//  Created by  rjt on 15/12/21.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EFEmptyEntity : EFEntity

@property (nonatomic) NSInteger                       indentationLevel;           // adjust content indent. default is 0
@property (nonatomic) CGFloat                         indentationWidth;           // width for each level. default is 10.0

@end
