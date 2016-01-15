//
//  STODBManager.h
//  CaoPanBao
//
//  Created by 财道 on 14/11/12.
//  Copyright (c) 2014年 weihui. All rights reserved.
//


#import "StockEntity.h"
#import "Singleton.h"


typedef enum {
    MatchingTypeStockCode,
    MatchingTypeStockName,
    MatchingTypeStockAbbr
}MatchingType;


@interface STODBManager : NSObject

@property (nonatomic,copy) NSString *searchText;
@property (nonatomic,strong) NSMutableArray *myStockArr;

single_interface(STODBManager)

//检查数据库版本号
-(void)checkNewVerson:(NSString*) currentVerson;

//向数据库插入股票entity
-(void)insertStock:(StockEntity *)entity;

//根据searchBar的搜索文字，匹配查询类型（汉字，数据，简拼），返回entity数组
- (NSArray *)searchStockWithMathingType:(MatchingType)type searchText:(NSString *)searchText;

//根据传入的nsarray返回股票entity数组
- (NSArray *)searchStockWithArray:(NSMutableArray *)array;

//判断entity，查询是否存在该类股票
- (BOOL)isStockExists:(StockEntity *)entity;

/**根据code精确查找数据*/
- (StockEntity *)accurateSearchWithStockCode:(NSString *)code;

/*获取我的自选股*/
- (NSArray *)getmyStcokList;

/*添加自选股*/
- (NSString *)addMyStockWithStockCode:(NSString *)code;

/*删除自选股*/
- (BOOL)deleteMyStockWithStockCode:(NSString *)code;

/*保存搜索记录*/
-(void)saveSearchHistory:(NSString *)code;

/*获取搜索记录*/
-(NSArray *)getSearchHistory;


/*保存浏览记录*/
-(void)saveVisitHistory:(NSString *)code;

/*获取浏览记录*/
-(NSArray *)getVisitHistory;

/*清空浏览记录*/
-(void)cleanVisitHistory;



/*检查股票更新时间*/
-(void)checkUpdateTime;


-(void)cleanMyStockArr;

- (MatchingType)matchingTypeWithSearchText:(NSString *)searchText;


@end
