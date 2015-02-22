//
//  TWUser.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface TWUser : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagLine;

+ (TWUser *) currentUser;
+ (void) setCurrentUser:(TWUser *) user;
+ (void) logout;

- (instancetype) initFromJson:(NSDictionary *) dictionaryValue;

@end
