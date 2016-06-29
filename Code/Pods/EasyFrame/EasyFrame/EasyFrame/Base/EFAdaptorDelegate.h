//
//  EFAdaptorProtocol.h
//  WeiPay
//
//  Created by zhuojian on 14-3-13.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class EFAdaptor;
@class EFSection;
@class EFEntity;
@class EFTextField,UITextView,UIView;

@protocol EFAdaptorDelegate <NSObject>

@optional

/** 自定义构造初始化Section */
-(EFSection*)EFAdaptor:(EFAdaptor*)adaptor initSectionClass:(Class)cls;


/** table编辑代理 **/
- (void)EFTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

/** table编辑代理 **/
- (BOOL)EFTableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath ;

/**
 首次初始化构造Section
 @param willDidLoadSection 初始化Section
 @param willDidLoadEntity 初始化Entity
 */
-(void)EFAdaptor:(EFAdaptor*)adaptor willDidLoadSection:(EFSection*)section willDidLoadEntity:(EFEntity*)entity;

-(void)EFAdaptor:(EFAdaptor*)adaptor forSection:(EFSection*)section forEntity:(EFEntity*)entity;

-(void)EFAdaptor:(EFAdaptor*)adaptor willDidLoadGroupSection:(EFSection*)section willDidLoadEntity:(EFEntity*)entity;

-(void)EFAdaptor:(EFAdaptor*)adaptor forGroupSection:(EFSection*)section forEntity:(EFEntity*)entity;

/** 选中某项Section时触发 */
-(void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity;


/** 文本框离开焦点触发 */
-(void)EFAdaptor:(EFAdaptor *)adaptor willChangeSection:(EFSection *)section willChangeTextField:(EFTextField *)textField;

//
//
///** 文本框进入焦点触发 */
//-(void)EFAdaptor:(EFAdaptor *)adaptor textFieldBeginEditing:(EFTextField *)textField;
//
///** 文本框进入焦点，返回偏移高度 */
//-(float)EFAdaptor:(EFAdaptor*)adaptor willOffsetForTextField:(EFTextField*)textField;
//
///** 文本框内容已更改 */
//-(void)EFAdaptor:(EFAdaptor *)adaptor textFieldEditChanged:(EFTextField *)textField;
//
///** 文本框内容是否需要变更 */
//- (BOOL)EFAdaptor:(EFAdaptor*)adaptor textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
//
///** 过滤点击手势,返回NO表示不做拦截，YES=》拦截手势 */
//-(BOOL)EFAdaptor:(EFAdaptor*)adaptor shouldTapView:(UIView*)tapView;
//
///** 单击tableview 任意位置触发手势(未做拦截的手势) */
//-(void)EFAdaptor:(EFAdaptor *)adaptor tapView:(UIView *)tapView;
//
///** 手势拦截触发后，是否取消正在进行的触摸事件(YES 取消当前触摸，NO 继续触摸) */
//-(BOOL)EFAdaptorShouldCancelsTouchesInView:(EFAdaptor*)adaptor;


@end

