//
//  TWTweet.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/19/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle.h>
#import "TWUser.h"

@interface TWTweet : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) TWUser *user;
@property (nonatomic, assign) NSInteger favorateNum;
@property (nonatomic, assign) NSInteger retweetNum;
@property (nonatomic, assign) NSInteger replyNum;
@property (nonatomic, assign) BOOL favorited;
@property (nonatomic, assign) BOOL retweeted;


- (instancetype) initFromJson:(NSDictionary *) dictionaryValue;

+ (NSArray *) tweetsWithArray:(NSArray *)array;

@end
