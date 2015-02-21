//
//  TwitterClient.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TwitterClient.h"

NSString * const kTwitterConsumerKey = @"4HOHHbwBLpqDCrujWyZJ8U6YU";
NSString * const kTwitterConsumerSecret = @"hIGTaXhbcrMO1lN6zaYxtPT7ZbDDbISbefc4Kpz14EFFX9kDhm";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";


@implementation TwitterClient

+ (TwitterClient *) sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    
    return instance;
}

-(void) retweet:(NSString *)tweetId {
    [[TwitterClient sharedInstance] GET:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"retweet success response: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"retweet failure response: %@", error);
    }];
}

@end
