//
//  TwitterClient.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "TWUser.h"
#import "TWTweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

-(void) retweet:(NSString *)tweetId;

-(void) favorite:(NSString *)tweetId;

-(void) updateStatus:(NSString *)status WithCompletion:(void (^)(TWTweet *newTweet, NSError *error)) completion;

- (void) loginWithCompletion:(void (^)(TWUser *user, NSError *error)) completion;

- (void) openURL:(NSURL *) url;

- (void) getUserInfo:(NSString *) userScreenName WithCompletion:(void (^)(NSDictionary *userDictionary, NSError *error)) completion;

- (void) getUserTimeline:(NSString *) userScreenName WithCompletion:(void (^)(NSArray *tweets, NSError *error)) completion;

@end
