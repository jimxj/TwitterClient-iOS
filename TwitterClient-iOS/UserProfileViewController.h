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

- (instancetype) initWithUserScreenName:(NSString *) screenName;

@end
