//
//  UserProfileCell.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 3/1/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "UserProfileCell.h"
#import "UIImageView+AFNetworking.h"

NSString * const kUserProfileCellName = @"UserProfileCell";

@interface UserProfileCell()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;

@end

@implementation UserProfileCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setUserInfoDictionary:(NSDictionary *)userDictionary {
    _userInfoDictionary = userDictionary;
    
    [self.userNameLabel setText:[userDictionary valueForKey:@"name"]];
    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@",[userDictionary valueForKey:@"screen_name"]]];
    [self.cityLabel setText:[userDictionary valueForKey:@"location"]];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:[userDictionary valueForKey:@"profile_image_url"]]];
    [self.tweetsCountLabel setText:[NSString stringWithFormat:@"%@",[userDictionary valueForKey:@"statuses_count"]]];
    [self.followingCountLabel setText:[NSString stringWithFormat:@"%@", [userDictionary valueForKey:@"friends_count"]]];
    [self.followerCountLabel setText:[NSString stringWithFormat:@"%@",[userDictionary valueForKey:@"followers_count"]]];
    
    [self.userNameLabel sizeToFit];
    [self.screenNameLabel sizeToFit];
    [self.tweetsCountLabel sizeToFit];
    [self.followingCountLabel sizeToFit];
    [self.followerCountLabel sizeToFit];
}

@end
