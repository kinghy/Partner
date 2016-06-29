//
//  EFSetEntity.m
//  EasyFrame
//
//  Created by  rjt on 15/9/30.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "EFSetEntity.h"

@implementation EFSetEntity

-(instancetype)init{
    if (self = [super init]) {
        _showsReorderControl = NO;
        _shouldIndentWhileEditing = YES;
        _accessoryType = UITableViewCellAccessoryNone;
        _editingAccessoryType = UITableViewCellAccessoryNone;
        _indentationLevel = 0;
        _indentationWidth = 10.0f;
    }
    return self;
}
@end
