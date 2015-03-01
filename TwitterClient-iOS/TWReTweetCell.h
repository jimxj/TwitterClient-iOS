//
//  TWReTweetCell.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/19/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TWTweet.h"

@class TWReTweetCell;

extern NSString * const kTweetCellName;

@protocol TweetCellProtocol

- (void) tweetCell:(TWReTweetCell *) tweetCell userImageDidTapped:(NSString *) screenName;

@end

@interface TWReTweetCell : UITableViewCell

@property (nonatomic, strong) TWTweet *tweet;

@property (nonatomic, weak) id<TweetCellProtocol> tweetHandler;

@end
