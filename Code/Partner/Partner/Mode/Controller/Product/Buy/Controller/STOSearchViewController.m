//
//  STOSearchViewController.m
//  QianFangGuJie
//
//  Created by 余龙 on 15/1/9.
//  Copyright (c) 2015年 余龙. All rights reserved.
//

#import "STOSearchViewController.h"
#import "STOSearchStockBll.h"
#import "IndexViewController.h"
//#import "MainViewController.h"
#import "UIBarButtonItem+YL.h"
#import "STODBManager.h"

@interface STOSearchViewController ()<UITextFieldDelegate> {
    STOSearchStockBll *_searchListBll;
}

@end

@implementation STOSearchViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 显示导航条
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.search becomeFirstResponder];
}

- (void)viewDidLoad {
    
    self.title = @"选择股票";
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleLightContent; 
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden=YES;

    [self.cancelBtn addTarget:self action:@selector(gotoBuyView) forControlEvents:UIControlEventTouchUpInside];
    
    //如果是主页push过来的话、左item是房子图标，不用更改
    //如果从买入界面过来的话、左返回按钮title
    if (self.canDismiss) {
        UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(gotoBuyView)];
        self.navigationItem.leftBarButtonItem = left;
    } else {
        UIBarButtonItem *left = [UIBarButtonItem buttonItemWithIcon:@"home" highlightedIcon:@"home_hover" target:self action:@selector(goBackProductionView)];
        self.navigationItem.leftBarButtonItem = left;
    }
    
    self.search.delegate = self;
    [self.search setValue:[UIColor colorWithRed:77/255.0 green:152/255.0 blue:242/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];

    [self.search addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.cancelBtn addTarget:self action:@selector(cancelText) forControlEvents:UIControlEventTouchUpInside];
    
    _searchListBll = [STOSearchStockBll bllWithController:self tableViewDict:@{kBllUniqueTable:_localStockTable}];
    [_searchListBll show];
    [self setUpForDismissKeyboard];
}






- (void)setUpForDismissKeyboard {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    __weak STOSearchViewController *mySelf = self;
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [ mySelf.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [mySelf.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.search endEditing:YES];
}

- (void)cancelText {
    self.search.text = @"";
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)textFieldEditChanged:(UITextField *)textField{
    [self showSearchContentWithSearchText:textField.text];
}


- (void)showSearchContentWithSearchText:(NSString *)searchText {
    
    _searchListBll.searchText = searchText;
    
}



#pragma mark - textFildDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString * searchText = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    //2.空格排除
    NSRange str =[searchText rangeOfString:@" "];
    if(str.location!=NSIntegerMax) return NO;
    
    
    return YES;
}




- (void)gotoBuyView {
    //保存历史搜索记录
    //[[STODBManager shareSTODBManager]saveSearchHistory: _searchListBll.searchText];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)goBackProductionView{
    //保存历史搜索记录
    //[[STODBManager shareSTODBManager]saveSearchHistory: _searchListBll.searchText];
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)dealloc {
    DDLogInfo(@"------------股票搜索控制器释放");
}



@end
