//
//  STOSearchStockBll.m
//  Partner
//
//  Created by  rjt on 15/10/22.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "STOSearchStockBll.h"
#import "STODBManager.h"
#import "STOStockListSection.h"
#import "StockEntity.h"

#define DATABASE_FILE_NAME @"stocklist.db"

@interface STOSearchStockBll ()
{
    NSString *_stockString;
    BOOL _isClick;
    BOOL haslogin;
}

@end

@implementation STOSearchStockBll

- (void)loadBll
{
    [super loadBll];
    
    _isClick = YES;

    self.manager = [STOProductManager shareSTOProductManager];
}

//copy file
- (void)copySotockDBFiler{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                               NSDocumentDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    //往应用程序路径中添加数据库文件名称，把它们拼接起来， 这里用到了宏定义（目的是不易出错)
    NSString *dbFilePath = [documentFolderPath stringByAppendingPathComponent:DATABASE_FILE_NAME];//#define DATABASE_FILE_NAME @"text.db"
    //1. 创建NSFileManager对象  NSFileManager包含了文件属性的方法
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //2. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:dbFilePath];
    //- (BOOL)fileExistsAtPath:(NSString *)path;
    
    //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist)
    {
        //拷贝数据库
        
        //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:DATABASE_FILE_NAME
                                  ofType:nil];
        //这一步实现数据库的添加，
        // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
        if (cp) {
            DDLogInfo(@"复制成功");
        }
    }
}

-(EFAdaptor *)loadEFUIWithTable:(EFTableView *)tableView andKey:(NSString *)key{
    EFAdaptor * adpator = [EFAdaptor adaptorWithTableView:tableView nibArray:@[@"STOStockListSection"] delegate:self];
    adpator.scrollEnabled = YES;
    return adpator;
}

- (void)setSearchText:(NSString *)searchText
{
    _searchText = searchText;
    
    MatchingType type = [self matchingTypeWithSearchText:searchText];
    
    NSArray *stockArr = [[STODBManager shareSTODBManager] searchStockWithMathingType:type searchText:searchText];
    _stockString = [stockArr firstObject];
    //移除之前的数据
    EFAdaptor *adaptor = self.pAdaptorDict[kBllUniqueTable];
    [adaptor clear];
    for (StockEntity *e in stockArr) {
        [adaptor addEntity:e withSection:[STOStockListSection class]];
    }
//
    [self.pAdaptorDict[kBllUniqueTable] notifyChanged];
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

- (void)EFAdaptor:(EFAdaptor *)adaptor forSection:(EFSection *)section forEntity:(EFEntity *)entity
{
    if ([section isMemberOfClass:[STOStockListSection class]]) {
        STOStockListSection *s = (STOStockListSection *)section;
        StockEntity *e = (StockEntity *)entity;
        s.stockNameLab.text = e.stockName;
        s.stockCodeLab.text = e.stockCode;
        //s.stockAb.text = e.stockAb;
        s.stockAb.text=@"已自选";
        s.addBtn.tag = [e.stockCode intValue];
        [s.addBtn addTarget:self action:@selector(addMyStock:) forControlEvents:UIControlEventTouchUpInside];
        
        BOOL isFocus=NO;
//        for (STOHqRecordsEntity *recordsEntity in myStockArray) {
//            if ([recordsEntity.stockcode isEqual:e.stockCode]) {
//                isFocus=YES;
//                break;
//            }
//        }
        if (isFocus) {
            s.addBtn.hidden=YES;
            s.stockAb.hidden=NO;
        }
        else{
            s.addBtn.hidden=NO;
            s.stockAb.hidden=YES;
        }
    }
}
//
//
//#pragma mark - 点击选择section
- (void)EFAdaptor:(EFAdaptor *)adaptor selectedSection:(EFSection *)section entity:(EFEntity *)entity
{
    if ([section isMemberOfClass:[STOStockListSection class]]) {
        //保存历史搜索记录
        //[[STODBManager shareSTODBManager]saveSearchHistory: self.searchText];
        
        StockEntity *e = (StockEntity *)entity;
        [self.manager chooseStock:e];
        
        [self.controller dismissViewControllerAnimated:YES completion:nil];
         
//        [[STODBManager shareSTODBManager]saveVisitHistory:e.stockCode];
        
//        //返回到行情界面，类型判断
//        __weak STOSearchViewController *c = (STOSearchViewController *)self.controller;
//        if (c.canDismiss) {
//            //传递股票信息
//            [self.controller dismissViewControllerAnimated:YES completion:nil];
//            
//        } else {
//            
//            //检查数据是否更新
//            NSDictionary *oldDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"stockdict"];
//            
//            if (![oldDict[@"stockname"] isEqualToString:e.stockName]) {
//                
//                [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"stockdict"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//            
//            STOProductViewController *main = [[STOProductViewController alloc] init];
//            
//            IndexViewController *index = [IndexViewController shareIndexViewController];
//            
//            [index.navigationController pushViewController:main animated:NO];
//            [self.controller dismissViewControllerAnimated:YES completion:nil];
//        }
        
        
    }
}

//
////谈话框
//- (void)wpAlertViewDelegateYesButtonClick:(id)sender andPayload:(id)payload
//{
//    UIAlertView *aler = (UIAlertView *)sender;
//    if (aler.tag == 50 ) {
//        _searchController.search.text = @"";
//    }
//}
//
//-(void)addMyStock:(UIButton*)button{
//    NSString *stockcode = [NSString stringWithFormat:@"%ld",(long)button.tag];
//    NSMutableString *code = [[NSMutableString alloc]init];
//    switch (stockcode.length) {
//        case 1:
//            [code appendFormat:@"00000%@",stockcode];
//            break;
//            
//        case 2:
//            [code appendFormat:@"0000%@",stockcode];
//            break;
//        case 3:
//            [code appendFormat:@"000%@",stockcode];
//            break;
//        case 4:
//            [code appendFormat:@"00%@",stockcode];
//            break;
//        case 5:
//            [code appendFormat:@"0%@",stockcode];
//            break;
//        default:
//            
//            [code appendFormat:@"%@",stockcode];
//            break;
//    }
//    //NSLog(@"code:%@",code);
//    
//    //检测是否已添加
//    BOOL isFocus=NO;
//    for (STOHqRecordsEntity *recordsEntity in myStockArray) {
//        if ([recordsEntity.stockcode isEqual:code]) {
//            isFocus=YES;
//            break;
//        }
//    }
//    if (isFocus) {
//        return;
//    }
//    
//    NSString *result=[[STODBManager shareSTODBManager]addMyStockWithStockCode:code];
//    [[NSNotificationCenter defaultCenter]postNotificationName:kRefreshMyStockListForMyStockBll object:nil];
//    if (![result isEqual:@""]) {
//        UIAlertView *alertview=[[UIAlertView alloc]initWithTitle:nil message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alertview show];
//    }
//    else{
//        [self.pAdaptor notifyChanged];
//    }
//    //    }
//}
//
//
//
//
//
//
//-(void)banClicked:(id)sender{
//    H5ViewController * adv = [[H5ViewController alloc] init];
//    adv.url = [NSString stringWithFormat: @"%@/stock/disallowList?type=0&session_id=%@",[ConfigManager shareConfigManager].h5Url,[[UserInfoManager shareUserInfoManager] getSessionID]];
//    [self.controller presentViewController:adv animated:YES completion:nil];
//}

- (void)dealloc {
    DDLogInfo(@"---------股票搜索展示页释放");
}


@end
