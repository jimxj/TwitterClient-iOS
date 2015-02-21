//
//  TWTweet.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/19/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TWTweet.h"
#import "NSMutableSet+OperationByValue.h"

@implementation TWTweet

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"idStr" : @"id_str",
             @"text": @"text",
             @"createdAt": @"created_at",
             @"user": @"user",
             @"favorateNum": @"favorite_count",
             @"retweetNum": @"retweet_count",
             @"replyNum": @"reply_count",
             @"favorited" : @"favorited",
             @"retweeted" : @"retweeted"
             };
}

+ (NSArray *) tweetsWithArray:(NSArray *)array {
    NSMutableArray *tweets = [NSMutableArray array];
    for(NSDictionary *dictionary in array) {
        [tweets addObject:[[TWTweet alloc] initFromJson:dictionary]];
    }
    
    return tweets;
}

- (instancetype)initFromJson:(NSDictionary *)dictionaryValue {
    __block NSMutableDictionary *filteredDictionary = [NSMutableDictionary dictionary];
    NSMutableSet *interestedKeys = [[NSSet setWithArray:[[TWTweet JSONKeyPathsByPropertyKey] allValues]] mutableCopy];
    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([interestedKeys containsObjectByValue:key]) {
            [filteredDictionary setObject:obj forKey:key];
        }
    }];
    NSLog(@"filteredDictionary : \n%@", filteredDictionary);
    //self = [super initWithDictionary:filteredDictionary error:nil];
    self = [MTLJSONAdapter modelOfClass:TWTweet.class fromJSONDictionary:filteredDictionary error:nil];
    if (self) {
        //self.user = [MTLJSONAdapter modelOfClass:TWUser.class fromJSONDictionary:filteredDictionary[@"user"] error:nil];
    }
    
    return self;
}

+ (NSValueTransformer *)createdAtJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
        return [[self dateFormatter] dateFromString:str];
    } reverseBlock:^(NSDate *date) {
        return [[self dateFormatter] stringFromDate:date];
    }];
//    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *) {
//        return [self.dateFormatter dateFromString:str];
//    } reverseBlock:^(NSDate *date) {
//        return [self.dateFormatter stringFromDate:date];
//    }];
}

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    return dateFormatter;
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:TWUser.class];
}


@end
