//
//  EFScrollViewController.m
//  Partner
//
//  Created by  rjt on 15/11/30.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "EFScrollViewController.h"

@interface EFScrollViewController ()

@end

@implementation EFScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fillParentEnabled = false;
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(loadSection)]) {
        self.pSection = [self loadSection];
        DDLogInfo(@"self.pSection.frame.frame.size.height=%f, self.pScrollView.frame.size.height=%f",self.pSection.frame.size.height, self.pScrollView.frame.size.height);
        if (self.fillParentEnabled) {
            self.pSection.frame = CGRectMake(0, 0, self.pScrollView.frame.size.width, self.pScrollView.frame.size.height);
        }else{
            self.pSection.frame = CGRectMake(0, 0, self.pScrollView.frame.size.width, self.pSection.frame.size.height);
            
        }
        
        [self.pScrollView addSubview:self.pSection];
        
    }
}

-(void)viewWillLayoutSubviews{
    //xib 中勾选了autolayout选项，在autolayout下，iOS计算UIScrollView的contentsize的机制是略有不同。在autolayout中，会在viewDidAppear之前根据subview的constraint重新计算UIScrollView的contentsize。 当在viewdidload里手动设置contentsize时，会再重新计算一次，把前面手动设置的值覆盖掉。
    if (!self.fillParentEnabled) {
        if ( self.pSection.frame.size.height > self.pScrollView.frame.size.height) {
            self.pScrollView.contentSize = CGSizeMake(self.pSection.frame.size.width, self.pSection.frame.size.height);
            self.pScrollView.scrollEnabled = YES;
        }
    }
//    self.pScrollView.scrollEnabled = self.scrollEnabled;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
