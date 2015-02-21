//
//  TwitterClient.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *) sharedInstance;

-(void) retweet:(NSString *)tweetId;

@end
