//
//  EFSection.h
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  @brief  section基类,section关联的view必须设置<autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
 *
 */
@interface EFSection : UIView
@property (weak,nonatomic) UITableViewCell* parentCell;
@end


@interface EFSectionInfo : NSObject

+(instancetype)infoWithName:(NSString*)sectionName andBounds:(CGRect)bounds;

@property (strong,nonatomic) NSString* name;
@property CGRect bounds;
@end