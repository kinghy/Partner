//
//  EFConnectorQueue.m
//  EasyFrame
//
//  Created by  rjt on 15/6/11.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//

#import "EFConnectorQueue.h"

@interface EFConnectorQueue()
@property (nonatomic,strong) NSMutableArray *queue;
@end;

@implementation EFConnectorQueue
+(instancetype)queue{
    return [[self alloc] init];
}

-(NSUInteger)count{
    return self.queue.count;
}

-(NSDictionary *)queueAtIndex:(NSInteger)index{
    return [self.queue objectAtIndex:index];
}

-(void)addParam:(EFConnectorParam *)param resultBlock:(EFConnQueueRetBlock)block{
    if (_queue==nil) {
        _queue = [[NSMutableArray alloc] init];
    }
    [_queue addObject:@{kEFConnectorQueueKeyParam:param,kEFConnectorQueueKeyBlock:block}];
}

@end
