//
//  TwitterClient.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TwitterClient.h"
#import "TWTweet.h"

NSString * const kTwitterConsumerKey = @"4HOHHbwBLpqDCrujWyZJ8U6YU";
NSString * const kTwitterConsumerSecret = @"hIGTaXhbcrMO1lN6zaYxtPT7ZbDDbISbefc4Kpz14EFFX9kDhm";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient ()

@property(nonatomic, strong) void (^loginCompletion)(TWUser *user, NSError *error);

@end

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

- (void) loginWithCompletion:(void (^)(TWUser *user, NSError *error)) completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"cptwitterdemo://oauth"] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSLog(@"Got request token : %@", requestToken );
        
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
        
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get request token : %@", error );
        self.loginCompletion(nil, error);
    }];
}

- (void) openURL:(NSURL *) url {
    [[TwitterClient sharedInstance] fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"Got access token %@ ", accessToken.token);
        
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"Current user json: %@", responseObject);
            TWUser *user = [[TWUser alloc] initFromJson:responseObject];
            [TWUser setCurrentUser:user];
            self.loginCompletion(user, nil);
            NSLog(@"Current user : %@", user);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Faile to get current user : %@", error);
            self.loginCompletion(nil, error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"Failed to get access token");
        self.loginCompletion(nil, error);
    }];
    
}

-(void) retweet:(NSString *)tweetId {
    [[TwitterClient sharedInstance] POST:[NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"retweet success response: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"retweet failure response: %@", error);
    }];
}

-(void) favorite:(NSString *)tweetId {
    [[TwitterClient sharedInstance] POST:[NSString stringWithFormat:@"1.1/favorites/create.json?id=%@", tweetId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"favorite success response: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"favorite failure response: %@", error);
    }];
}

-(void) updateStatus:(NSString *)status WithCompletion:(void (^)(TWTweet *newTweet, NSError *error)) completion {
    [[TwitterClient sharedInstance] POST:@"1.1/statuses/update.json" parameters: @{@"status": status} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"update status success response: %@", responseObject);
        completion([[TWTweet alloc] initFromJson:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"update status failure response: %@", error);
        completion(nil, error);
    }];
}

- (void) getUserInfo:(NSString *) userScreenName WithCompletion:(void (^)(NSDictionary *userDictionary, NSError *error)) completion {
    [[TwitterClient sharedInstance] POST:@"1.1/users/lookup.json" parameters: @{@"screen_name": userScreenName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"getUserInfo success response: %@", responseObject);
        completion(((NSArray *)responseObject)[0], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"getUserInfo failure response: %@", error);
        completion(nil, error);
    }];
}

- (void) getUserTimeline:(NSString *) userScreenName WithCompletion:(void (^)(NSArray *tweets, NSError *error)) completion {
    [[TwitterClient sharedInstance] GET:@"1.1/statuses/user_timeline.json" parameters: @{@"screen_name": userScreenName} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"home_timeline json: %@", responseObject);
        //TWUser *user = [[TWUser alloc] initWithDictionary:responseObject error:nil];
        //NSLog(@"Current user : %@", user);
        
        NSArray *newTweets = [TWTweet tweetsWithArray:responseObject];
        completion(newTweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Faile to get home_timeline : %@", error);
        completion(nil, error);
    }];
}


@end
