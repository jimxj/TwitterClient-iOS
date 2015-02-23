//
//  TwitterClient.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "TWUser.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

-(void) retweet:(NSString *)tweetId;

-(void) favorite:(NSString *)tweetId;

-(void) updateStatus:(NSString *)status;

- (void) loginWithCompletion:(void (^)(TWUser *user, NSError *error)) completion;

- (void) openURL:(NSURL *) url;

@end
