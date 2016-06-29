//
//  EFSetEntity.h
//  EasyFrame
//
//  Created by  rjt on 15/9/30.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "EFEntity.h"

@interface EFSetEntity : EFEntity
@property (nonatomic, strong, nullable) UIImage  *image;

@property (nonatomic, strong, nullable) NSString *text;
@property (nonatomic, strong, nullable) NSString *detailText;

@property (nonatomic) UITableViewCellSelectionStyle   selectionStyle;             // default is UITableViewCellSelectionStyleBlue.
@property (nonatomic) BOOL                            showsReorderControl;        // default is NO
@property (nonatomic) BOOL                            shouldIndentWhileEditing;   // default is YES.  This is unrelated to the indentation level below.

@property (nonatomic) UITableViewCellAccessoryType    accessoryType;              // default is UITableViewCellAccessoryNone. use to set standard type
@property (nonatomic, strong, nullable) UIView       *accessoryView;              // if set, use custom view. ignore accessoryType. tracks if enabled can calls accessory action
@property (nonatomic) UITableViewCellAccessoryType    editingAccessoryType;       // default is UITableViewCellAccessoryNone. use to set standard type
@property (nonatomic, strong, nullable) UIView       *editingAccessoryView;       // if set, use custom view. ignore editingAccessoryType. tracks if enabled can calls accessory action

@property (nonatomic) NSInteger                       indentationLevel;           // adjust content indent. default is 0
@property (nonatomic) CGFloat                         indentationWidth;           // width for each level. default is 10.0
@end
