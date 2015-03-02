//
//  TWUser.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TWUser.h"
#import "NSMutableSet+OperationByValue.h"
#import "TwitterClient.h"

NSString * const UserDidLoginNotification = @"UserDidLoginNotification";
NSString * const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface TWUser()

@property (nonatomic, strong) NSDictionary *dictionary;

@end

@implementation TWUser

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"idStr": @"id_str",
             @"name": @"name",
             @"screenName": @"screen_name",
             @"profileImageUrl": @"profile_image_url"
             //@"tagLine": @"description"
            };
}

static TWUser *_currentUser = nil;
NSString * const kCurrentUserKey = @"kCurrentUserKey";

+ (TWUser *) currentUser {
    if(!_currentUser) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if(data) {
            NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [MTLJSONAdapter modelOfClass:TWUser.class fromJSONDictionary:dictionary error:nil];
        }
    }
    return _currentUser;
}

+ (void) setCurrentUser:(TWUser *) user {
    _currentUser = user;
    
    NSData *data = nil;
    if(_currentUser) {
        data = [NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONDictionaryFromModel:user] options:0 error:NULL];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void) logout {
    [TWUser setCurrentUser:nil];
    [[TwitterClient sharedInstance].requestSerializer removeAccessToken];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

- (instancetype) initFromJson:(NSDictionary *) dictionaryValue {
    //NSLog(@"dictionaryValue : \n%@", dictionaryValue);
    __block NSMutableDictionary *filteredDictionary = [NSMutableDictionary dictionary];
    NSMutableSet *interestedKeys = [[NSSet setWithArray:[[TWUser JSONKeyPathsByPropertyKey] allValues]] mutableCopy];
    [dictionaryValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if([interestedKeys containsObjectByValue:key]) {
            [filteredDictionary setObject:obj forKey:key];
        }
    }];
    //NSLog(@"filteredDictionary : \n%@", filteredDictionary);
    //self = [super initWithDictionary:filteredDictionary error:nil];
    self = [MTLJSONAdapter modelOfClass:TWUser.class fromJSONDictionary:filteredDictionary error:nil];
    //if (self == nil) return nil;
//    self = [super init];
//    if(self) {
//        _idStr = [filteredDictionary valueForKey:@"id_str"];
//        _name = [filteredDictionary valueForKey:@"name"];
//        _screenName = [filteredDictionary valueForKey:@"screen_name"];
//        _profileImageUrl = [filteredDictionary valueForKey:@"profile_image_url"];
//        //_tagLine = [filteredDictionary valueForKey:@"description"];
//    }
    
    return self;
}

//+ (NSValueTransformer *)profileImageUrlJSONTransformer {
//    // use Mantle's built-in "value transformer" to convert strings to NSURL and vice-versa
//    // you can write your own transformers
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}


@end
