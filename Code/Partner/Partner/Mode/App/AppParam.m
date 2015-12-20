//
//  AppParam.m
//  EasyFrame
//
//  Created by  rjt on 15/6/16.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import "AppParam.h"
#import "UserManager.h"
#import "AuthenticateEntity.h"

@implementation AppParam
-(NSDictionary *)getHeaders{
    NSMutableDictionary *headDict = [[NSMutableDictionary alloc] init];
//    NSString* did = [EFCommonFunction getUniqueDeviceIdentifier];
//    NSString* sseionid = [UserManager shareUserManager].myEntity.session_id;
    NSString* token = [UserManager shareUserManager].myEntity.value;
    
    //设置响应头字符串
    [headDict setObject:token?token:@"" forKey:@"x-access-token"];
//    [headDict setObject:sseionid?sseionid:@"" forKey:@"x-qfgj-sid"];
//    [headDict setObject:uid?uid:@"" forKey:@"x-qfgj-uid"];
    return headDict;
}

//兼容老版本翻译网络连接加上前缀
-(NSString *)getOperatorTypeTranslate{
    
    NSString* strUrl = [self getOperatorType];
    
    if ([[self getOperatorType] rangeOfString:@"Interface"].length){ //对行情接口做处理
        
        NSString *baseUrl = HQ_URL_DAY;
        NSRange str = [strUrl rangeOfString:@"NightInterface"];
        if (str.location==NSIntegerMax) {//如果是夜市请使用NightInterface
            baseUrl = HQ_URL_DAY;
        } else {
            baseUrl = HQ_URL_NIGHT;
        }
        
        //行情
        if ([[self getOperatorType] isEqualToString:@"hqInterface"]|| [[self getOperatorType] isEqualToString:@"hqNightInterface"]) {
            strUrl = [NSString stringWithFormat:@"%@/?opt=gethqs&name=%@",baseUrl,[self valueForKey:@"code"]];
        }
        
        //分时
        if ([[self getOperatorType] isEqualToString:@"chartInterface"] || [[self getOperatorType] isEqualToString:@"chartNightInterface"]) {
            strUrl = [NSString stringWithFormat:@"%@/?opt=getmins&name=%@",baseUrl,[self valueForKey:@"code"]];
        }
        //交易量
        if ([[self getOperatorType] isEqualToString:@"volchartInterface"]|| [[self getOperatorType] isEqualToString:@"volchartNightInterface"]) {
            strUrl = [NSString stringWithFormat:@"%@/?short_term=1&opt=getmins&name=%@",baseUrl,[self valueForKey:@"code"]];
        }
        //k线
        if ([[self getOperatorType] isEqualToString:@"kChartInterface"] || [[self getOperatorType] isEqualToString:@"kChartNightInterface"]) {
            strUrl = [NSString stringWithFormat:@"%@/?opt=get_kline&name=%@&day_count=%@",baseUrl,[self valueForKey:@"code"],[self valueForKey:@"days"]];
        }
        
        //盘口
        if ([[self getOperatorType] isEqualToString:@"pankouInterface"] || [[self getOperatorType] isEqualToString:@"pankouNightInterface"]) {
            strUrl = [NSString stringWithFormat:@"%@/?opt=gethq&name=%@",baseUrl,[self valueForKey:@"code"]];
        }
    }else{
        strUrl = [NSString stringWithFormat:@"%@%@",SERVER_URL,strUrl];
    }
    
    return strUrl;
}

-(void)catchErrors:(NSError *)error withEntity:(EFEntity *)entity{
    BOOL flg = YES;
    
    BOOL filterFlg = NO;
    AppEntity *e = nil;
    if ([entity isKindOfClass:[AppEntity class]]) {
        e = (AppEntity*)entity;
    }
    for (int i = 0; i < self.filterErrorCodes.count; i++) {
        NSNumber *code = self.filterErrorCodes[i];
        if ((e.code && [e.code integerValue] == [code integerValue]) || [code  isEqual: @IGNORE_ERROR_CODE]) {
            filterFlg = YES;
            break;
        }
    }
    
    if (!filterFlg && (error || e.code)) {
        // 防止弹出多个alert
        if (error) {
            [EFCommonFunction showNotifyHUDAtViewBottom:[[UIApplication sharedApplication] keyWindow] withErrorMessage:@"网络异常，请重试！"];

        }else{
            [EFCommonFunction showNotifyHUDAtViewBottom:[[UIApplication sharedApplication] keyWindow] withErrorMessage:e.message];
        }
        
        flg = NO;
        
    }
//    return flg;
}

@end