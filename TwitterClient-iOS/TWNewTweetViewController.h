//
//  TWNewTweetViewController.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/21/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"

@protocol NewTweetProtocol
- (void) newTweet:(TWTweet *) tweet;
@end

@interface TWNewTweetViewController : UIViewController

@property(nonatomic, weak) id<NewTweetProtocol> tweetCreationListner;

@end
