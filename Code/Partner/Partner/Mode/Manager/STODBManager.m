//
//  STODBManager.m
//  CaoPanBao
//
//  Created by 财道 on 14/11/12.
//  Copyright (c) 2014年 weihui. All rights reserved.
//

#import "STODBManager.h"
//#import "STODbManagerMock.h"
//#import "STODbMangerEntity.h"
//#import "STOHqEntity.h"

#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
//#import "UserInfoManager.h"
#import "UserManager.h"

//#import "STOCheckStockUpdateMock.h"

#define kUserSearchHistory @"kUserSearchHistory"
#define kUserVisitHistory @"kUserVisitHistory"

@interface STODBManager()
{
    FMDatabase *_fmdb;
    FMDatabaseQueue *_dbQueue;
    NSString *_documents;
}
//@property(strong,nonatomic)STODbManagerParam* param;
@property(strong,nonatomic)NSString* localVerson;
//@property(strong,nonatomic)STODbManagerMock* dbMock;
@property(assign,nonatomic)BOOL isSuccess;
//@property(strong,nonatomic)STOCheckStockUpdateEntity* mySTOCheckStockUpdateEntity;
//@property(strong,nonatomic)STOCheckStockUpdateMock* mySTOCheckStockUpdateMock;
//@property(strong,nonatomic)STOCheckStockUpdateParam* mySTOCheckStockUpdateParam;
@end
@implementation STODBManager
single_implementation(STODBManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *documentFile = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _documents = documentFile;
        NSString *path = [documentFile stringByAppendingPathComponent:@"stocklist.db"];
        
        DDLogInfo(@"*******%@",path);
        
        _fmdb = [[FMDatabase alloc]initWithPath:path];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
        BOOL ret = [_fmdb open];
        if (ret) {
            NSString *str = @"create table if not exists stocklist (id integer primary key autoincrement,stock_code text(32),stock_name text(128),stock_abbr text(32),code_shsz text(32))";
            if (![_fmdb executeUpdate:str]) {
                DDLogInfo(@"创建表失败");
            }
            
            str = @"create table if not exists mystocklist (id integer primary key autoincrement,stock_code text(32),user_id text(32))";
            if (![_fmdb executeUpdate:str]) {
                DDLogInfo(@"创建自选股表失败");
            }
            
            str = @"create view stocklist_v as select sl.id,sl.stock_code,sl.stock_name,sl.stock_abbr,sl.code_shsz,msl.stock_code as mslstock_code,ifnull(msl.stock_code,0) as choosed from stocklist as sl left join mystocklist as msl on sl.stock_code = msl.stock_code";
            if (![_fmdb executeUpdate:str]) {
                DDLogInfo(@"创建自选股表失败");
            }
            
        } else {
            DDLogInfo(@"打开失败");
        }
    }
    return self;
}

//-(void)initQuickMock{
//    self.param = [STODbManagerParam param];
//    self.dbMock = [STODbManagerMock mock];
//    self.dbMock.delegate = self;
//}

-(void)checkNewVerson:(NSString *)currentVerson
{
    
//    [self initQuickMock];
//    self.localVerson = currentVerson;
//
//    [self.dbMock run:self.param];
}

//-(void)QUMock:(QUMock *)mock entity:(QUEntity *)entity
//{
//    
//    updateTradeDataEntity* e = (updateTradeDataEntity*)entity;
//    
//    if (![[e.res_data[@"version"] description] isEqualToString:[NSString stringWithFormat:@"%@",self.localVerson] ]) {
//        
//        if ([_fmdb open]) {
//            NSString *str = @"create table if not exists temp (id integer primary key autoincrement,stock_code text(32),stock_name text(128),stock_abbr text(32),code_shsz text(32))";
//            [_fmdb executeUpdate:str];
//        
//        } else {
//            DDLogInfo(@"建表失败");
//            return;
//        }
//        
//        
//
//        
//        //开始异步下载url
//        void (^block) () = ^{
//            NSString *strUrl = e.res_data[@"url"];
//            if (strUrl!=nil) {
//#ifdef WP_LINKTEST_SERVER
//                strUrl = [strUrl stringByReplacingOccurrencesOfString:@"192.168.5.96" withString:@"180.168.176.2"];
//#endif
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
//                
//                id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//                
//                if ([jsonData isKindOfClass:[NSArray class]]) {
//                    
//                    NSArray *dataArray = (NSArray *)jsonData;
//                    
//                    [_fmdb beginTransaction];
//                    [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//                        [_fmdb executeUpdate:@"INSERT INTO temp (stock_code,stock_name,stock_abbr,code_shsz) VALUES(?,?,?,?)",obj[@"code"],obj[@"name"],obj[@"abbr"],obj[@"code_shsz"]];
//                    }];
//                    [_fmdb commit];;
//                    
//                }
//
//            }
//            
//        };
//        
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
//        dispatch_group_t group = dispatch_group_create();
//        
//        dispatch_group_async(group, queue, block);
//        
//        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//            [_fmdb executeUpdate:@"DROP TABLE stocklist"];
//            [_fmdb executeUpdate:@"ALTER TABLE temp RENAME TO stocklist"];
//
//            [_fmdb close];
//            
//            DDLogInfo(@"-=========股票数据库插入完毕");
//            [[NSUserDefaults standardUserDefaults] setValue:e.res_data[@"version"] forKey:@"stockDB_version"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        });
////        BACK(block);
//        
//    }
//    
//}

-(void)insertStock:(StockEntity *)entity
{
    NSString *str = @"insert into stocklist(stock_code,stock_name,stock_abbr) values(?,?,?)";
    if ([_fmdb open]) {
        if(![_fmdb executeUpdate:str,entity.stockCode,entity.stockName,entity.stockAb])
        {
            DDLogInfo(@"插入失败");
        }
    }
    [_fmdb close];
    
}

- (BOOL)isStockExists:(StockEntity *)entity{
    
    NSString *str = @"select stock_name,stock_code,stock_abbr from stocklist  where stock_code = ?";
    FMResultSet *set = [_fmdb executeQuery:str,entity.stockCode];
    return [set next];
}


- (StockEntity *)accurateSearchWithStockCode:(NSString *)code {
    
    StockEntity *entity = [StockEntity entity];
    NSString *str = @"select stock_name,stock_code,stock_abbr,code_shsz,choosed from stocklist_v  where stock_code = ?";

    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set = [db executeQuery:str,code];
        while ([set next]) {
            
            entity.stockName = [set stringForColumn:@"stock_name"];
            entity.stockCode = [set stringForColumn:@"stock_code"];
            entity.stockAb = [set stringForColumn:@"stock_abbr"];
            entity.codeShsz = [set stringForColumn:@"code_shsz"];
            entity.choosed = [NSNumber numberWithInt:[[set stringForColumn:@"choosed"] intValue]];
        }
        
    }];
    [_fmdb close];
    return entity;
}






- (NSArray *)searchStockWithArray:(NSMutableArray *)array
{
    NSMutableArray* stockArr = [NSMutableArray array];
    [stockArr removeAllObjects];
    NSString *searchString=@"''";
    
    for (int i=0; i<array.count; i++) {
        searchString=[searchString stringByAppendingString:[NSString stringWithFormat:@",'%@'",[array objectAtIndex:i]]];
    }
    
    NSString *sqliteStr= [NSString stringWithFormat:@"select stock_name,stock_code,stock_abbr,code_shsz,choosed from stocklist_v where stock_code in (%@) limit 30",searchString];;

    
    
    NSMutableArray *tempArray=[[NSMutableArray alloc]initWithCapacity:0];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //        FMResultSet *set = [db executeQuery:sqliteStr,searchText];
        FMResultSet *set;
        //会db对象加锁，保证临界区内的代码线程安全
        set = [db executeQuery:sqliteStr];
        
        while ([set next]) {
            StockEntity *entity = [StockEntity entity];
            entity.stockName = [set stringForColumn:@"stock_name"];
            entity.stockCode = [set stringForColumn:@"stock_code"];
            entity.stockAb = [set stringForColumn:@"stock_abbr"];
            entity.codeShsz = [set stringForColumn:@"code_shsz"];
            entity.choosed = [NSNumber numberWithInt:[[set stringForColumn:@"choosed"] intValue]];
            [tempArray addObject:entity];
        }
    }];
    
    
    for (int i=(int)array.count-1; i>=0; i--) {
        NSString *code=[array objectAtIndex:i];
        for (int j=0; j<tempArray.count; j++) {
            StockEntity *entity=[tempArray objectAtIndex:j];
            if ([entity.stockCode isEqualToString:code]) {
                [stockArr addObject:entity];
                [tempArray removeObjectAtIndex:j];
                break;
            }
        }
    }
    
    
    
    [_fmdb close];
    return stockArr;
}








//,..  暂不支持全拼查询
- (NSArray *)searchStockWithMathingType:(MatchingType)type searchText:(NSString *)searchText
{
    NSMutableArray* stockArr = [NSMutableArray array];
    [stockArr removeAllObjects];
    
    NSString *sqliteStr;
    switch (type) {
        case MatchingTypeStockName:
            sqliteStr = [NSString stringWithFormat:@"select stock_name,stock_code,stock_abbr,code_shsz,choosed from stocklist_v where stock_name like '%%%@%%' limit 500",searchText];
            break;
        case MatchingTypeStockCode:
            sqliteStr = [NSString stringWithFormat:@"select stock_name,stock_code,stock_abbr,code_shsz,choosed from stocklist_v where stock_code like '%%%@%%' limit 500",searchText];;
            break;
        case MatchingTypeStockAbbr:
            sqliteStr = [NSString stringWithFormat:@"select stock_name,stock_code,stock_abbr,code_shsz,choosed from stocklist_v where stock_abbr like '%%%@%%' limit 500",searchText];
            break;
            
        default:
            return nil;
    }
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //        FMResultSet *set = [db executeQuery:sqliteStr,searchText];
        FMResultSet *set;
                                      //会db对象加锁，保证临界区内的代码线程安全
        set = [db executeQuery:sqliteStr];
    
        while ([set next]) {
            StockEntity *entity = [StockEntity entity];
            entity.stockName = [set stringForColumn:@"stock_name"];
            entity.stockCode = [set stringForColumn:@"stock_code"];
            entity.stockAb = [set stringForColumn:@"stock_abbr"];
            entity.codeShsz = [set stringForColumn:@"code_shsz"];
            entity.choosed = [NSNumber numberWithInt:[[set stringForColumn:@"choosed"] intValue]];
            [stockArr addObject:entity];
        }
        
    }];
    [_fmdb close];
    return stockArr;
}

/*获取我的自选股*/
- (NSArray *)getmyStcokList{
    if (!_myStockArr) {
        _myStockArr = [NSMutableArray array];
        
        NSString *sqliteStr;
        sqliteStr = [NSString stringWithFormat:@"select s2.id as id,s1.stock_name,s1.stock_code,s1.stock_abbr,s1.code_shsz from mystocklist as s2 left join stocklist as s1 on s2.[stock_code]=s1.stock_code where s2.user_id = '%@' order by id DESC;",[self getUidWithDefault]];
        //    sqliteStr = [NSString stringWithFormat:@"select * from mystocklist;"];
        [_dbQueue inDatabase:^(FMDatabase *db) {
            //        FMResultSet *set = [db executeQuery:sqliteStr,searchText];
            FMResultSet *set;
            //会db对象加锁，保证临界区内的代码线程安全
            set = [db executeQuery:sqliteStr];
            
            while ([set next]) {
                StockEntity *entity = [StockEntity entity];
                entity.stockName = [set stringForColumn:@"stock_name"];
                entity.stockCode = [set stringForColumn:@"stock_code"];
                entity.stockAb = [set stringForColumn:@"stock_abbr"];
                entity.codeShsz = [set stringForColumn:@"code_shsz"];
                entity.choosed = @1;
                [_myStockArr addObject:entity];
            }
            
        }];
        [_fmdb close];
    }
//
    
    return _myStockArr;
}

-(NSMutableArray *)myStockArr{
    if(_myStockArr == nil){
        [self refreshMyStockArr];
    }
    return _myStockArr;
}

-(void)cleanMyStockArr{
    [_myStockArr removeAllObjects];
    _myStockArr=nil;
}

/*添加自选股*/
- (NSString *)addMyStockWithStockCode:(NSString *)code{
    NSString *result = @"";
    _isSuccess = NO;
    //检验code是否是股票包中的代码
    NSString *sqliteStr;
    DEFINED_WEAK_SELF
    sqliteStr = [NSString stringWithFormat:@"select stock_name from stocklist where stock_code = '%@';",code];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set;
        //会db对象加锁，保证临界区内的代码线程安全
        set = [db executeQuery:sqliteStr];
        while ([set next]) {
          _self.isSuccess = YES;
        }
    }];
    [_fmdb close];
    
    if (!self.isSuccess) {
        result = @"在股票包未找到该股票";
        return result;
    }
    
    sqliteStr = [NSString stringWithFormat:@"select stock_code from mystocklist where stock_code = '%@' and user_id = '%@';",code,[self getUidWithDefault]];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *set;
        //会db对象加锁，保证临界区内的代码线程安全
        set = [db executeQuery:sqliteStr];
        while ([set next]) {
            _self.isSuccess = NO;
        }
    }];
    [_fmdb close];
    
    if (!self.isSuccess) {
        result = @"该股票已添加";
        return result;
    }
    
    NSArray *arr = [self getmyStcokList];
    if ([arr count]>=30) {
        result = @"自选股股数不能超过30个";
        return result;
    }
    NSString *str = @"insert into mystocklist (stock_code,user_id) values(?,?)";
    if ([_fmdb open]) {
        if(![_fmdb executeUpdate:str,code,[self getUidWithDefault]])
        {
            DDLogInfo(@"插入失败");
            result=@"插入失败";
        }
    }
    [_fmdb close];
    
    [self refreshMyStockArr];
    
    return result;
}

/*删除自选股*/
- (BOOL)deleteMyStockWithStockCode:(NSString *)code{
    BOOL result = YES;
    NSString *str =[NSString stringWithFormat:@"delete from mystocklist where stock_code = '%@' and user_id = '%@'",code,[self getUidWithDefault]];
    if ([_fmdb open]) {
        if(![_fmdb executeUpdate:str])
        {
            DDLogInfo(@"删除失败");
            result=NO;
        }
    }
    [_fmdb close];    
    [self refreshMyStockArr];
    return result;
    
}

- (void)dealloc {
    
}




/*保存浏览记录*/
-(void)saveVisitHistory:(NSString *)code{
    if(code!=nil&&![code isEqualToString:@""]){


        NSMutableString *userSearchCode = [[NSMutableString alloc]initWithString:kUserVisitHistory];
        [userSearchCode appendString:[self getUidWithDefault]];
        
        NSMutableArray *historyArray=[[[NSUserDefaults standardUserDefaults]objectForKey:userSearchCode]mutableCopy];
        
        if (historyArray==nil) {
            historyArray=[[NSMutableArray alloc]initWithCapacity:0];
        }
        
        
        if (historyArray.count>=30) {
            [historyArray removeObjectAtIndex:0];
        }
        for (int i=0; i<historyArray.count; i++) {
            if ([[historyArray objectAtIndex:i]isEqualToString:code]) {
                [historyArray removeObjectAtIndex:i];
            }
        }
        [historyArray addObject:code];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:userSearchCode];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}


-(void)cleanVisitHistory{

        NSMutableString *userSearchCode = [[NSMutableString alloc]initWithString:kUserVisitHistory];
        [userSearchCode appendString:[self getUidWithDefault]];
        
        NSMutableArray *historyArray=[[[NSUserDefaults standardUserDefaults]objectForKey:userSearchCode]mutableCopy];
        
        if (historyArray==nil) {
            historyArray=[[NSMutableArray alloc]initWithCapacity:0];
        }
        
        
        [historyArray removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:historyArray forKey:userSearchCode];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
}


/*获取浏览记录*/
-(NSArray *)getVisitHistory{
    NSMutableString *userSearchCode = [[NSMutableString alloc]initWithString:kUserVisitHistory];
    [userSearchCode appendString:[self getUidWithDefault]];
    NSMutableArray *historyArray=[[NSUserDefaults standardUserDefaults]objectForKey:userSearchCode];
    
    return [[STODBManager shareSTODBManager]searchStockWithArray:historyArray];

}




/*保存搜索记录*/
-(void)saveSearchHistory:(NSString *)code{
    if(code!=nil&&![code isEqualToString:@""]){
    NSMutableString *userSearchCode = [[NSMutableString alloc]initWithString:kUserSearchHistory];
    
    [userSearchCode appendString:[self getUidWithDefault]];
    NSUserDefaults *userdefualts = [NSUserDefaults standardUserDefaults];
    [userdefualts setObject:code forKey:userSearchCode];
        [userdefualts synchronize];
    }
}

/*获取搜索记录*/
-(NSArray *)getSearchHistory{
    NSMutableString *userSearchCode = [[NSMutableString alloc]initWithString:kUserSearchHistory];
    NSString *uid = [self getUidWithDefault];
    [userSearchCode appendString:uid==nil?@"default":uid];
    NSString *searchCode = [[NSUserDefaults standardUserDefaults] objectForKey:userSearchCode];
    MatchingType type = [self matchingTypeWithSearchText:searchCode];
    return [self searchStockWithMathingType:type searchText:searchCode];
}

- (MatchingType)matchingTypeWithSearchText:(NSString *)searchText{
    NSString *regexHanzi = @"^[\u2E80-\u9FFF]+$";
    NSString *regexAbbr = @"^[A-Za-z]+$";
    NSString *regexNum = @"^([0-9])+$";
    
    //排除乱码，用于新数据存储到数据库
    
    NSPredicate *predicateHanzi = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexHanzi];
    NSPredicate *predicateNum = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexNum];
    NSPredicate *predicateAbbr = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexAbbr];
    if ([predicateHanzi evaluateWithObject:searchText]) {
        return MatchingTypeStockName;
    } else if ([predicateAbbr evaluateWithObject:searchText]) {
        return MatchingTypeStockAbbr;
    } else if ([predicateNum evaluateWithObject:searchText]){
        return MatchingTypeStockCode;
    }
    return 0;
}

/*刷新自选股列表*/
-(void)refreshMyStockArr{
    if (!_myStockArr) {
        _myStockArr = [NSMutableArray array];
    }
    [_myStockArr removeAllObjects];
    NSString *sqliteStr;
    sqliteStr = [NSString stringWithFormat:@"select s2.id as id,s1.stock_name,s1.stock_code,s1.stock_abbr,s1.code_shsz from mystocklist as s2 left join stocklist as s1 on s2.[stock_code]=s1.stock_code where s2.user_id = '%@' order by id DESC;",[self getUidWithDefault]];
    //    sqliteStr = [NSString stringWithFormat:@"select * from mystocklist;"];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        //        FMResultSet *set = [db executeQuery:sqliteStr,searchText];
        FMResultSet *set;
        //会db对象加锁，保证临界区内的代码线程安全
        set = [db executeQuery:sqliteStr];
        
        while ([set next]) {
            StockEntity *entity = [StockEntity entity];
            entity.stockName = [set stringForColumn:@"stock_name"];
            entity.stockCode = [set stringForColumn:@"stock_code"];
            entity.stockAb = [set stringForColumn:@"stock_abbr"];
            entity.codeShsz = [set stringForColumn:@"code_shsz"];
            entity.choosed = @1;
            [_myStockArr addObject:entity];
        }
        
    }];
    [_fmdb close];

}

//获取UID，如果没有UID则返回字符串default
-(NSString*)getUidWithDefault{
    NSString *uid = [[UserManager shareUserManager] getUserID];
    return (uid==nil || [uid isEqualToString:@""])?@"default":uid;
}

/*检查股票更新时间*/
-(void)checkUpdateTime{
//    _mySTOCheckStockUpdateMock= [STOCheckStockUpdateMock mock];
//    _mySTOCheckStockUpdateParam = [STOCheckStockUpdateParam param];
//
//    DEFINED_WEAK_SELF
//    _mySTOCheckStockUpdateMock.returnBlock = ^(QUNetAdaptor *adaptor,QUNetResponse *response,AppMock *mock){
//        STOCheckStockUpdateEntity *e = (STOCheckStockUpdateEntity *)response.pEntity;
//        _self.mySTOCheckStockUpdateEntity = e;
//        if([e.result isEqualToString:@"y"]){
//            NSString *url = [e.path_name objectForKey:e.update_time];
//            if ([e.this_all intValue]==1) {//全部更新
//                [_self refreshAllSTOTableWithURL:url];
//            }else{//部分更新
//                [_self refreshPartSTOTableWithURL:url];
//            }
//        }
//    };
//    NSString *time= [[NSUserDefaults standardUserDefaults]objectForKey:@"STODBUpdateTime"];
//    if (time&&![time isEqualToString:@""]) {
//        _mySTOCheckStockUpdateParam.stocktime = time;
//        [_mySTOCheckStockUpdateMock run:_mySTOCheckStockUpdateParam];
//    }else{
        if ([_fmdb open]) {
            NSString *str = @"create table if not exists stocktemp (id integer primary key autoincrement,stock_code text(32),stock_name text(128),stock_abbr text(32),code_shsz text(32))";
            [_fmdb executeUpdate:str];
            
        } else {
            DDLogInfo(@"建表失败");
            return ;
        }
        //预先加载本地股票包，防止网络获取失败
//        NSString *str = STOData;
        void (^block) () = ^{
//                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"StockData" ofType:@"plist"];
            NSMutableDictionary *dir = [[NSMutableDictionary alloc]initWithContentsOfFile:plistPath];
            NSString *str = [dir objectForKey:@"stockdata"];
            NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
            
            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            if ([jsonData isKindOfClass:[NSArray class]]) {
                
                NSArray *dataArray = (NSArray *)jsonData;
                
                [_fmdb beginTransaction];
                [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
                    [_fmdb executeUpdate:@"INSERT INTO stocktemp (stock_code,stock_name,stock_abbr,code_shsz) VALUES(?,?,?,?)",obj[@"code"],obj[@"name"],obj[@"abbr"],obj[@"code_shsz"]];
                }];
                [_fmdb commit];;
            }
           
        };
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
        dispatch_group_t group = dispatch_group_create();
        dispatch_group_async(group, queue, block);
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            [_fmdb executeUpdate:@"DROP TABLE stocklist"];
            [_fmdb executeUpdate:@"ALTER TABLE stocktemp RENAME TO stocklist"];
            
            [_fmdb close];
            DDLogInfo(@"-=========股票数据库插入完毕");
//            [_mySTOCheckStockUpdateMock run:_mySTOCheckStockUpdateParam];
        });

//    }
}

//更新全部股票只是适用于新方法
-(void)refreshAllSTOTableWithURL:(NSString *)strUrl{
//    if ([_fmdb open]) {
//        NSString *str = @"create table if not exists stocktemp (id integer primary key autoincrement,stock_code text(32),stock_name text(128),stock_abbr text(32),code_shsz text(32))";
//        [_fmdb executeUpdate:str];
//        
//    } else {
//        DDLogInfo(@"建表失败");
//        return ;
//    }
//#ifdef WP_LINKTEST_SERVER
//    strUrl = [strUrl stringByReplacingOccurrencesOfString:@"192.168.5.96" withString:@"180.168.176.2"];
//#endif
//    //开始异步下载url
//    void (^block) () = ^{
//
//        if (strUrl!=nil) {
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
//            
//            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            
//            if ([jsonData isKindOfClass:[NSArray class]]) {
//                
//                NSArray *dataArray = (NSArray *)jsonData;
//                
//                [_fmdb beginTransaction];
//                [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//                    [_fmdb executeUpdate:@"INSERT INTO stocktemp (stock_code,stock_name,stock_abbr,code_shsz) VALUES(?,?,?,?)",obj[@"code"],obj[@"name"],obj[@"abbr"],obj[@"code_shsz"]];
//                }];
//                [_fmdb commit];;
//            }
//        }
//    };
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_group_async(group, queue, block);
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        [_fmdb executeUpdate:@"DROP TABLE stocklist"];
//        [_fmdb executeUpdate:@"ALTER TABLE stocktemp RENAME TO stocklist"];
//        
//        [_fmdb close];
//        DDLogInfo(@"-=========股票数据库插入完毕");
//        [[NSUserDefaults standardUserDefaults] setObject:_mySTOCheckStockUpdateEntity.update_time forKey: @"STODBUpdateTime"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    });
}
//更新增量股票
-(void)refreshPartSTOTableWithURL:(NSString *)strUrl{
//    if ([_fmdb open]) {
//        if (strUrl!=nil) {
//#ifdef WP_LINKTEST_SERVER
//            strUrl = [strUrl stringByReplacingOccurrencesOfString:@"192.168.5.96" withString:@"180.168.176.2"];
//#endif
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:strUrl]];
//            
//            id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            
//            if ([jsonData isKindOfClass:[NSArray class]]) {
//                
//                NSArray *dataArray = (NSArray *)jsonData;
//                
//                [_fmdb beginTransaction];
//                NSMutableString *deletStr = [[NSMutableString alloc]initWithString: @"DELETE FROM stocklist WHERE stock_code IN ("];
//                //删除数据
//                [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//                    [deletStr appendString:@"'"];
//                    [deletStr appendString:obj[@"code"]];
//                    [deletStr appendString:@"',"];
//                }];
//                NSRange r = NSMakeRange(deletStr.length-1, 1);
//                [deletStr deleteCharactersInRange:r];
//                [deletStr appendString:@");"];
//                [_fmdb executeUpdate:deletStr];
//                
//                //插入数据
//                [dataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
//                    [_fmdb executeUpdate:@"INSERT INTO stocklist (stock_code,stock_name,stock_abbr,code_shsz) VALUES(?,?,?,?)",obj[@"code"],obj[@"name"],obj[@"abbr"],obj[@"code_shsz"]];
//                }];
//                [_fmdb commit];
//            }
//        }
//        [_fmdb close];
//        DDLogInfo(@"-=========股票数据库更新完毕");
//        [[NSUserDefaults standardUserDefaults] setObject:_mySTOCheckStockUpdateEntity.update_time forKey: @"STODBUpdateTime"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
}


@end
