//
//  TWUser.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TWUser.h"
#import "NSMutableSet+OperationByValue.h"

@implementation TWUser

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"name": @"name",
             @"screenName": @"screen_name",
             @"profileImageUrl": @"profile_image_url",
             @"tagLine": @"description"
            };
}

//- (instancetype) initWithDictionary:(NSDictionary *) dictionaryValue error:(NSError **)error {
//    NSLog(@"dictionaryValue : \n%@", dictionaryValue);
//    __block NSMutableDictionary *filteredDictionary = [NSMutableDictionary dictionary];
//    NSMutableSet *interestedKeys = [[NSSet setWithArray:[[TWUser JSONKeyPathsByPropertyKey] allValues]] mutableCopy];
//    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//        if([interestedKeys containsObjectByValue:key]) {
//            [filteredDictionary setObject:obj forKey:key];
//        }
//    }];
//    NSLog(@"filteredDictionary : \n%@", filteredDictionary);
//    //self = [super initWithDictionary:filteredDictionary error:nil];
//    self = [MTLJSONAdapter modelOfClass:TWUser.class fromJSONDictionary:dictionaryValue error:nil];
//    if (self == nil) return nil;
//    
//    return self;
//}

//+ (NSValueTransformer *)profileImageUrlJSONTransformer {
//    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
//    // you can write your own transformers
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}


@end
