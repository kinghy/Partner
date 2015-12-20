//
//  ContractDetailViewController.m
//  Partner
//
//  Created by  rjt on 15/10/13.
//  Copyright © 2015年 Kinghy. All rights reserved.
//

#import "ContractDetailViewController.h"
#import "CustomIOSAlertView.h"
#import "ContractAlert.h"
#import "ContractManager.h"
#import "DocumentEntity.h"

@interface ContractDetailViewController ()<UIAlertViewDelegate,UIWebViewDelegate>{
    MBProgressHUD* hud ;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet EFButton *confirmBtn;

@end

@implementation ContractDetailViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.statusBarStyle = UIStatusBarStyleLightContent;
    self.title = @"合约签署";
    // Do any additional setup after loading the view from its nib.
    DocumentEntity *docEnttiy = [ContractManager shareContractManager].createdDocument;
    
    NSURL *url = [NSURL URLWithString:docEnttiy.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    self.webView.delegate = self;
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.confirmBtn.layer setCornerRadius:5.f];
    self.confirmBtn.selectedBackgroundColor = kBtnColorSelected;

}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
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

- (IBAction)createClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确认要签署合约" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}

#pragma marks - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        DEFINED_WEAK_SELF
        [[ContractManager shareContractManager] signDocument:^(EFEntity *entity, NSError *error) {
            CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
            NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"ContractAlert" owner:_self options:nil];
            
            ContractAlert *view = (ContractAlert*)nibs[0];
            view.img.image = [UIImage imageNamed:@"contract_successed"];
            view.label.text = @"恭喜，合约签署成功！ \n 祝您投资成功！";
            
            view.label.numberOfLines = 0;
            //        alert.dialogView = view;
            // Add some custom content to the alert view
            [alertView setContainerView:view];
            // Modify the parameters
            // You may use a Block, rather than a delegate.
            [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
                [alertView close];
                [AppUtil gotoIndex:YES];
            }];
            
            [alertView setUseMotionEffects:false];
            
            alertView.buttonTitles = @[@"确定"];
            [alertView show];
        }];
    }
}

@end
