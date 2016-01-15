//
//  AppDelegate.m
//  EasyFrame
//
//  Created by kinghy on 15/6/7.
//  Copyright (c) 2015年 交易支点. All rights reserved.
//


#import "AppDelegate.h"
#import "EFAlertViewCommon.h"
#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "STODBManager.h"
#import "UserManager.h"

@interface AppDelegate ()<EFAlertViewCommonDelegate>
@property (strong,nonatomic) NSString* updateUrl;
@property (strong,nonatomic) NSString* version;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // Enable XcodeColors
    setenv("XcodeColors", "YES", 0);
    
    // Standard lumberjack initialization
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // And then enable colors
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    // Check out default colors:
    // Error : Red
    // Warn  : Orange
    
    DDLogError(@"Paper jam");                              // Red
    DDLogWarn(@"Toner is low");                            // Orange
    DDLogInfo(@"Warming up printer (pre-customization)");  // Default (black)
    DDLogVerbose(@"Intializing protcol x26");              // Default (black)
    
    // Now let's do some customization:
    // Info  : Pink
    
#if TARGET_OS_IPHONE
    UIColor *pink = [UIColor colorWithRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
#else
    NSColor *pink = [NSColor colorWithCalibratedRed:(255/255.0) green:(58/255.0) blue:(159/255.0) alpha:1.0];
#endif
    
    [[DDTTYLogger sharedInstance] setForegroundColor:pink backgroundColor:nil forFlag:DDLogFlagInfo];
    
    DDLogInfo(@"Warming up printer (post-customization)"); // Pink !
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.nav = [[UINavigationController alloc] initWithRootViewController:[LoginViewController controllerWithModel:[LoginViewModel viewModel] nibName:@"LoginViewController" bundle:[NSBundle mainBundle]]];
    self.window.rootViewController = self.nav;
    
//    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[STOProductMarketViewController alloc] initWithNibName:@"STOProductMarketViewController" bundle:[NSBundle mainBundle]]];
    [self.window makeKeyAndVisible];
   
    //初始化股票包
    [[STODBManager shareSTODBManager] checkUpdateTime];
    
    return YES;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
