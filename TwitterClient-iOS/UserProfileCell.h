//
//  UserProfileCell.h
//  TwitterClient-iOS
//
//  Created by Jim Liu on 3/1/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kUserProfileCellName;

@interface UserProfileCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *userInfoDictionary;

@end
