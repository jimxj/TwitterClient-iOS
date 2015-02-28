//
//  ProfileCell.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/26/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "ProfileCell.h"
#import "TWUser.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileCell()

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;



@end

@implementation ProfileCell

- (void)awakeFromNib {
    // Initialization code
    NSLog(@"awakeFromNib of ProfielCell is called");
    
    self.userProfileImage.layer.cornerRadius = 3;
    self.userProfileImage.clipsToBounds = YES;
    
    TWUser *currentUser = [TWUser currentUser];
    [self.userNameLabel setText:currentUser.name];
    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", currentUser.screenName]];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
}

-(void) setData {
    NSLog(@"setData of ProfielCell is called");
    TWUser *currentUser = [TWUser currentUser];
    [self.userNameLabel setText:currentUser.name];
    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", currentUser.screenName]];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
