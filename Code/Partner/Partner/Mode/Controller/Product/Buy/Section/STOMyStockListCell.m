//
//  STOMyStockListCell.m
//  QianFangGuJie
//
//  Created by tongshangren on 15/8/18.
//  Copyright (c) 2015年 JYZD. All rights reserved.
//

#import "STOMyStockListCell.h"
@implementation STOMyStockListCell

- (void)awakeFromNib {
    
    
    self.change.clipsToBounds=YES;
    [[self.change layer]setCornerRadius:3.0];

    // Initialization code
}
- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
//    for (UIView *subview in self.subviews) {
//
//        for (UIView *subview2 in subview.subviews) {
//
//            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) { // move delete confirmation view
//
//                [subview bringSubviewToFront:subview2];
//
//            }
//        }
//    }
//
//    for (UIView *subView in self.subviews) {
//        if ([NSStringFromClass([subView class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
//            ((UIView *)[subView.subviews firstObject]).backgroundColor = Color_Bg_RGB(243, 243, 243);
//            [((UIButton *)[subView.subviews firstObject]) setTitle:@"删除自选" forState:UIControlStateNormal];
//            ((UIButton *)[subView.subviews firstObject]).titleLabel.font = [UIFont systemFontOfSize:12.0f];
//            [((UIButton *)[subView.subviews firstObject]) setTitleColor:Color_Bg_007aff forState:UIControlStateNormal];
//            
//        }
//    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-( void )willTransitionToState:( UITableViewCellStateMask )state{
    
    [ super willTransitionToState :state];
    
//    if ((state & UITableViewCellStateShowingDeleteConfirmationMask ) == UITableViewCellStateShowingDeleteConfirmationMask ){
//        
//        //        [self recurseAndReplaceSubViewIfDeleteConfirmationControl:self.subviews];
//        
//        [ self performSelector : @selector (recurseAndReplaceSubViewIfDeleteConfirmationControl:) withObject : self . subviews afterDelay : 0 ];
//        
//    }
    
}
-( void )recurseAndReplaceSubViewIfDeleteConfirmationControl:( NSArray *)subviews{
    
////    NSString *delete_button_name = @"！delete！！" ;
//    
//    for ( UIView *subview in subviews)
//        
//    {
//        
//        
//        /**
//         
//         *  ios7
//         
//         */
//        
//        if ([ NSStringFromClass ([subview class ]) isEqualToString : @"UITableViewCellDeleteConfirmationButton" ])
//            
//        {
//            
//            UIButton *deleteButton = ( UIButton *)subview;
//            deleteButton.backgroundColor = Color_Bg_RGB(243, 243, 243);
//            [deleteButton setTitle:@"删除自选" forState:UIControlStateNormal];
//            deleteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
//            [deleteButton setTitleColor:Color_Bg_007aff forState:UIControlStateNormal];
//            
//
//            
//        }
//        if ([subview. subviews count ]> 0 ){
//            
//            [ self recurseAndReplaceSubViewIfDeleteConfirmationControl :subview. subviews ];
////
//        }
//        
//    }
    
}



@end
