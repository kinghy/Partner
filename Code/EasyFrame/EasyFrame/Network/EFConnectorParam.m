//
//  EFConnectorParam.m
//  EasyFrame
//
//  Created by  rjt on 15/6/9.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import "EFConnectorParam.h"

@interface EFConnectorParam()
@end

@implementation EFConnectorParam{
    
}
+(instancetype)param{
    return [[self alloc] init];
}

+(instancetype)paramWithUrl:(NSString*)url method:(NSString*)method params:(NSDictionary*)params headers:(NSDictionary*)headers entClass:(Class)cls{

    return [[self alloc] initWithUrl:url method:method params:params headers:headers entClass:cls];
}

-(instancetype)initWithUrl:(NSString *)url method:(NSString *)method params:(NSDictionary *)params headers:(NSDictionary *)headers entClass:(Class)cls{
    self = [self init];
    _url = url;
    _headers = headers;
    _method = method;
    _dict = [NSMutableDictionary dictionaryWithDictionary:params] ;
    _cls = cls;
    return self;
}

-(NSString *)getMethod{
    if (!_method) {
        _method = kMethodGet;
    }
    return kMethodGet;
}

-(NSString *)getOperatorType{
    return _url;
}

-(NSString *)getOperatorTypeTranslate{
    return [self getOperatorType];
}

-(Class)getEntityClass{
    return _cls;
}

-(NSDictionary *)getHeaders{
    return _headers;
}

-(NSMutableDictionary *)dict{
    if (_dict==nil) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return _dict;
}

-(double)delayRequestTimeOut{
    return 15.f;
}

- (NSString *)getAliasName {
    return nil;
}

-(void)catchErrors:(NSError *)error withEntity:(EFEntity *)entity{

}

-(void)dealloc{
//    show_dealloc_info(self);
}

@end


