//
//  AppDelegate.m
//  PetsAlliance
//
//  Created by Mark Miyashita on 6/10/13.
//  Copyright (c) 2013 Mark Miyashita. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"keychainID" accessGroup:nil];
    [keychain setObject:@"Pets Alliance" forKey: (__bridge id)kSecAttrService];

    // NUI for buttons and labels
    [NUISettings initWithStylesheet:@"custom"];
    [NUIAppearance init];
    
    MyPetViewController *myPetViewController = [[MyPetViewController alloc] init];
    UIViewController *trainingViewController = [[TrainingViewController alloc] init];
    UIViewController *battleViewController = [[BattleViewController alloc] init];
    UIViewController *theMasterViewController = [[TheMasterViewController alloc] init];
    UIViewController *navigatorViewController = [[NavigatorViewController alloc] init];
    
    UINavigationController *myPetNavigationController = [[MyPetNavigationController alloc] initWithRootViewController:myPetViewController];
    UINavigationController *trainingNavigationController = [[TrainingNavigationController alloc] initWithRootViewController:trainingViewController];
    UINavigationController *battleNavigationController = [[BattleNavigationController alloc] initWithRootViewController:battleViewController];
    UINavigationController *theMasterNavigationController = [[UINavigationController alloc] initWithRootViewController:theMasterViewController];
    UINavigationController *navigatorNavigationController = [[UINavigationController alloc] initWithRootViewController:navigatorViewController];
    
    theMasterNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    navigatorNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[myPetNavigationController, trainingNavigationController, battleNavigationController, theMasterNavigationController, navigatorNavigationController];

    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];

    // Login logic.
    LoginViewController *loginController = [[LoginViewController alloc] init];
    LoginNavigationController *loginNavigationController = [[LoginNavigationController alloc] initWithRootViewController:loginController];

    NSUUID *vendorIdObject = [[UIDevice currentDevice] identifierForVendor];
    NSString *uuid = [vendorIdObject UUIDString];
    NSString *email = [keychain objectForKey:(__bridge id)kSecAttrAccount];
    NSString *password = [keychain objectForKey:(__bridge id)kSecValueData];
    NSDictionary *auth = @{ @"app_id":uuid, @"email":email, @"password":password};
    
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
    
    //let AFNetworking manage the activity indicator
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    // Initialize HTTPClient
    NSURL *localURL = [NSURL URLWithString:LOCALURL];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:localURL];
    
    //we want to work with JSON-Data
    [client setDefaultHeader:@"Accept" value:RKMIMETypeJSON];
    
    // Initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    [RKObjectManager setSharedManager:objectManager];
    
    // Setup our object mappings
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"userID",
     @"username" : @"username",
     @"email" : @"email",
     @"money" : @"money",
     @"bank" : @"bank",
     @"money_rate" : @"moneyRate",
     @"skill_level" : @"skillLevel",
     }];
    
    RKObjectMapping *petMapping = [RKObjectMapping mappingForClass:[Pet class]];
    [petMapping addAttributeMappingsFromDictionary:@{
     @"id" : @"statusID",
     @"created_at" : @"createdAt",
     @"text" : @"text",
     @"url" : @"urlString",
     @"in_reply_to_screen_name" : @"inReplyToScreenName",
     @"favorited" : @"isFavorited",
     }];
    
    RKRelationshipMapping *relationshipMapping = [RKRelationshipMapping relationshipMappingFromKeyPath:@"user"
                                                                                             toKeyPath:@"user"
                                                                                           withMapping:userMapping];
    [petMapping addPropertyMapping:relationshipMapping];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    
    [PAURLRequest requestWithURL:@"iphone" method:RKRequestMethodGET parameters:auth objectMapping:userMapping keyPath:@"user" delegate:self successBlock:^{
        NSLog(@"successfully logged in!");
        [hud hide:YES];
    } failureBlock:^{
        [hud hide:YES];
        double delayInSeconds = 0.1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.window.rootViewController presentViewController:loginNavigationController animated:YES completion:nil];
        });
    }];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
