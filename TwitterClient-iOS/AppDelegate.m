//
//  AppDelegate.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TwitterClient.h"
#import "TWUser.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = [[LoginViewController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    return YES;
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

#pragma mark - OAuth

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got access token %@ ", accessToken.token);
        
        [[TwitterClient sharedInstance].requestSerializer saveAccessToken:accessToken];
        
        UINavigationController *nvc = [[UINavigationController alloc] init];
        nvc.navigationBar.translucent = YES;
        nvc.navigationBar.barStyle = UIBarStyleBlack;
        nvc.navigationBar.tintColor = [UIColor whiteColor];
        nvc.navigationBar.backgroundColor = [UIColor redColor];
        [nvc setViewControllers:@[[[MainViewController alloc] init]]];
        
        [self.window.rootViewController presentViewController:nvc animated:YES completion:nil ];
        
        
//        [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"Current user json: %@", responseObject);
//            TWUser *user = [[TWUser alloc] initWithDictionary:responseObject error:nil];
//            NSLog(@"Current user : %@", user);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Faile to get current user : %@", error);
//        }];
//        
//        [[TwitterClient sharedInstance] GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"Current user json: %@", responseObject);
//            TWUser *user = [[TWUser alloc] initWithDictionary:responseObject error:nil];
//            NSLog(@"Current user : %@", user);
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"Faile to get current user : %@", error);
//        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get access token");
    }];
    
    return YES;
}

@end
