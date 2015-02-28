//
//  LeftViewController.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/26/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TwitterManuItem) {
    TwitterManuItemUserProfile,
    TwitterManuItemHomeTimeLine,
    TwitterManuItemMentions
};

@protocol ManuSwitchProtocal

-(void) manuDidChanged:(TwitterManuItem) manuItem;

@end

@interface LeftViewController : UIViewController

@property (nonatomic, weak) id<ManuSwitchProtocal> manuHandler;

@end
