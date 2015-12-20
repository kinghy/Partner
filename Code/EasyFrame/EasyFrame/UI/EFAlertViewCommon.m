//
//  EFAlertViewCommon.m
//  WeiboPay
//
//  Created by Mark on 12-12-25.
//  Copyright (c) 2012年 WeiboPay. All rights reserved.
//

#import "EFAlertViewCommon.h"

static EFAlertViewCommon* currentAlertViewCommon = nil;

@implementation EFAlertViewCommon

@synthesize delegate;
@synthesize alertView;
@synthesize payload;

- (void)showAlertType:(NSInteger)type andText:(NSString*)message andTitle:(NSString*)title andYesButton:(NSString*)yesText_ andNoButton:(NSString*)noText_ andDelegate:(id)delegate_ andTag:(NSInteger)tag_
{
    _alertType = type;
    
    if (_alertType == EFALERTCOMMON_TYPE_ONE_BUTTON)
    {
        NSString* yesText = yesText_;
        if (yesText == nil) {
            yesText = @"确定";
        }
        
        self.alertView = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:[EFAlertViewCommonCallback shareEFAlertViewCallback]
                          cancelButtonTitle:nil
                          otherButtonTitles:yesText, nil];
    }
    else
    {
        NSString* yesText = yesText_;
        NSString* noText = noText_;
        if (yesText == nil) {
            yesText = @"是";
        }
        if (noText == nil) {
            noText = @"否";
        }
        
        self.alertView = [[UIAlertView alloc]
                          initWithTitle:title
                          message:message
                          delegate:[EFAlertViewCommonCallback shareEFAlertViewCallback]
                          cancelButtonTitle:noText
                          otherButtonTitles:yesText, nil];
    }
    
    self.alertView.tag = tag_;
    self.delegate = delegate_;
    currentAlertViewCommon = self;
    
    [[EFAlertViewCommonCallback shareEFAlertViewCallback] addAlertView:self.alertView type:type delegate:delegate_ payload:self.payload];
    
    [alertView show];
}

+ (void)closeCurrentAlertView
{
    [currentAlertViewCommon.alertView dismissWithClickedButtonIndex:-1 animated:NO];
}

+ (BOOL)isShowAlertView
{
    if (currentAlertViewCommon)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


-(void)dealloc{
    // EFNSLOG(@"%@",self);
}

@end




@implementation EFAlertViewCommonCallback
static EFAlertViewCommonCallback* shareEFAlertViewCommonCallback;

+(id)shareEFAlertViewCallback{
    if(!shareEFAlertViewCommonCallback)
        shareEFAlertViewCommonCallback=[[EFAlertViewCommonCallback alloc] init];
    
    return shareEFAlertViewCommonCallback;
}

-(id)init{
    self=[super init];
    
    self.alertDict=[[NSMutableDictionary alloc] initWithCapacity:50];
    
    return self;
}


-(void)addAlertView:(UIAlertView*)alertView type:(NSInteger)type delegate:(id<EFAlertViewCommonDelegate>)delegate payload:(id)payload
{
    if(!payload)
        payload=[NSNull null];
    
    NSDictionary* dict=nil;
    
    if(delegate)
        dict=@{@"view": alertView,@"delegate":delegate,@"type":@(type),@"payload":payload};
    else
        dict=@{@"view": alertView,@"type":@(type),@"payload":payload};
    
    NSString* key=[NSString stringWithFormat:@"%ld",alertView.hash];
    [self.alertDict setObject:dict forKey:key];
}


-(void)remove:(NSString*)key{
    [self.alertDict removeObjectForKey:key];
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* key=[NSString stringWithFormat:@"%ld",alertView.hash];
    NSDictionary* dict=self.alertDict[key];
    
    id delegate=[dict objectForKey:@"delegate"];
    NSNumber* numberType=[dict objectForKey:@"type"];
    NSInteger _alertType=[numberType integerValue];
    id payload=[dict objectForKey:@"payload"];
    
    if([payload isKindOfClass:[NSNull class]])
        payload=nil;
    
    if (buttonIndex == 0)
    {
        if (_alertType == EFALERTCOMMON_TYPE_ONE_BUTTON)
        {
            if(!delegate)
            {
                // EFNSLOG(@"%@",delegate);
            }
            if ([delegate respondsToSelector:@selector(efAlertViewDelegateConfirmButtonClick:)])
            {
                [delegate efAlertViewDelegateConfirmButtonClick:alertView];
            }
        }
        else
        {
            if ([delegate respondsToSelector:@selector(efAlertViewDelegateNoButtonClick:)])
            {
                [delegate efAlertViewDelegateNoButtonClick:alertView];
            }
        }
    }
    else if (buttonIndex == 1)
    {
        if (_alertType == EFALERTCOMMON_TYPE_ONE_BUTTON)
        {
            
        }
        else
        {
            if ([delegate respondsToSelector:@selector(efAlertViewDelegateYesButtonClick:)])
            {
                [delegate efAlertViewDelegateYesButtonClick:alertView];
            }
            if ([delegate respondsToSelector:@selector(efAlertViewDelegateYesButtonClick:andPayload:)])
            {
                [delegate efAlertViewDelegateYesButtonClick:alertView andPayload:payload];
            }
        }
    }
    
    
    
    //    currentAlertViewCommon = nil;
    //
    //    [self remove:key];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString* key=[NSString stringWithFormat:@"%lu",(unsigned long)alertView.hash];
    NSDictionary* dict=self.alertDict[key];
    
    id delegate=[dict objectForKey:@"delegate"];
    NSNumber* numberType=[dict objectForKey:@"type"];
    NSInteger _alertType=[numberType integerValue];
    id payload=[dict objectForKey:@"payload"];
    
    if([payload isKindOfClass:[NSNull class]])
        payload=nil;
    
    
    if (buttonIndex == 0)
    {
        if (_alertType == EFALERTCOMMON_TYPE_ONE_BUTTON)
        {
            
        }
        else
        {
            
        }
    }
    else if (buttonIndex == 1)
    {
        if (_alertType == EFALERTCOMMON_TYPE_ONE_BUTTON)
        {
            
        }
        else
        {
            if ([delegate respondsToSelector:@selector(efAlertViewDelegateDidDismissYesButtonClick:)])
            {
                [delegate efAlertViewDelegateDidDismissYesButtonClick:alertView];
            }
        }
    }
    
    currentAlertViewCommon = nil;
    
    [self remove:key];
}


@end
