//
//  TWTweetDetailViewController.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/21/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"

@interface TWTweetDetailViewController : UIViewController

@property (nonatomic, strong) TWTweet *tweet;

-(instancetype) initWithTweet:(TWTweet *) tweet;

@end
