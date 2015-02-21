//
//  TWUser.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/17/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Mantle.h>

@interface TWUser : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *screenName;
@property (nonatomic, copy, readonly) NSString *profileImageUrl;
@property (nonatomic, copy, readonly) NSString *tagLine;

@end
