//
//  UserProfileViewController.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/27/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, assign) BOOL hasNavigationBar;

- (instancetype) initWithUserScreenName:(NSString *) screenName hasNavigationbar:(BOOL) hasNavigationBar;

@end
