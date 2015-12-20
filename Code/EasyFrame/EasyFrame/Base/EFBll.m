//
//  EFBll.m
//  EasyFrame
//
//  Created by  rjt on 15/9/24.
//  Copyright © 2015年 交易支点. All rights reserved.
//

#import "EFBll.h"
#import "EFTableView.h"
#import "EFBaseViewController.h"

@implementation EFBll

+(instancetype)bll{
    return [[self alloc] init];
}


+(instancetype)bllWithController:(EFBaseViewController *)controller tableViewDict:(NSDictionary *)tables{
    EFBll* selfBll=[self bll];
    selfBll.controller=controller;
    selfBll.pAdaptorDict = [NSMutableDictionary dictionary];
    selfBll.pTableDict = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsStrongMemory valueOptions:NSPointerFunctionsWeakMemory];
    NSEnumerator *keys = [tables keyEnumerator];
    for (NSString *name in keys) {
        [selfBll.pTableDict setObject:[tables objectForKey:name] forKey:name];
    }
    
    [selfBll.controller registerBll:selfBll];
    [selfBll loadBll];
    
    return selfBll;
}

-(void)loadBll{
    _isHidden = NO;
    [self loadEFManager];
    NSEnumerator *keys = [self.pTableDict keyEnumerator];
    for (NSString *name in keys) {
        EFAdaptor *adpator = [self loadEFUIWithTable:[self.pTableDict objectForKey:name] andKey:name];
        if (adpator) {
            [self.pAdaptorDict setObject:adpator forKey:name];
        }
    }
}

-(void)loadEFManager{

}

-(void)controllerDidAppear{
    
}
-(void)controllerWillAppear{
    
}
-(void)controllerDidDisappear{
    
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    return nil;
}

-(void)hide{
    _isHidden = YES;
    NSEnumerator* enu = [self.pTableDict keyEnumerator];
    for (NSString* str in enu) {
        ((EFTableView*)[self.pTableDict objectForKey:str]).hidden = YES;
    }
}

-(void)show{
    _isHidden = NO;
    NSEnumerator* enu = [self.pTableDict keyEnumerator];
    for (NSString* str in enu) {
        ((EFTableView*)[self.pTableDict objectForKey:str]).hidden = NO;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    show_dealloc_info(self);
}

@end
