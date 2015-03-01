//
//  TWReTweetCell.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/19/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TWReTweetCell.h"
#import "NSDate+TimeAgo.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"

NSString * const kTweetCellName = @"TWReTweetCell";

@interface TWReTweetCell()

@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorateNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *testImage;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedFlagImage;
@property (weak, nonatomic) IBOutlet UIImageView *favoratedFlagImage;
@property (weak, nonatomic) IBOutlet UIImageView *retweetHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *retweetedUserLabel;



@end

@implementation TWReTweetCell

- (void)awakeFromNib {
    // Initialization code
    self.testImage.layer.cornerRadius = 5;
    self.testImage.clipsToBounds = YES;
    
    UITapGestureRecognizer *retweetTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retweetFlagTaped)];
    [self.retweetedFlagImage addGestureRecognizer:retweetTap];
    
    UITapGestureRecognizer *favoriteTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(favoriteFlagTaped)];
    [self.favoratedFlagImage addGestureRecognizer:favoriteTap];
    
    UITapGestureRecognizer *userProfileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserProfileImageTapped:)];
    [self.testImage addGestureRecognizer:userProfileImageTap];
}

- (IBAction)onUserProfileImageTapped:(UITapGestureRecognizer *)sender {
    [self.tweetHandler tweetCell:self userImageDidTapped:self.tweet.user.screenName];
}


//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void) setTweet:(TWTweet *)tweet {
    _tweet = tweet;
    
    [self.tweetTextLabel setText:tweet.text];
    [self.timestampLabel setText:[tweet.createdAt timeAgoSimple]];
    [self.replyNumLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.replyNum]];
    [self.retweetNumLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.retweetNum]];
    [self.favorateNumLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.favorateNum]];
    [self.userNameLabel setText:tweet.user.name];
    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", tweet.user.screenName]];
    [self.testImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    
    if(tweet.retweeted) {
        self.retweetedFlagImage.image = [UIImage imageNamed:@"retweet_on"];
        
        self.retweetHeaderImage.hidden = NO;
        self.retweetLabel.hidden = NO;
    } else {
        self.retweetedFlagImage.image = [UIImage imageNamed:@"retweet"];
        
        self.retweetHeaderImage.hidden = YES;
        self.retweetLabel.hidden = YES;
    }
    
    if(tweet.favorited) {
        self.favoratedFlagImage.image = [UIImage imageNamed:@"favorite_on"];
    } else {
        self.favoratedFlagImage.image = [UIImage imageNamed:@"favorite"];
    }
}


- (void) retweetFlagTaped {
    if(self.tweet.retweeted) {
        self.retweetedFlagImage.image = [UIImage imageNamed:@"retweet"];
        self.tweet.retweetNum--;
    } else {
        self.retweetedFlagImage.image = [UIImage imageNamed:@"retweet_on"];
        self.tweet.retweetNum++;
    }
    
    self.tweet.retweeted = !self.tweet.retweeted;
    
    [self.retweetNumLabel setText:[NSString stringWithFormat:@"%ld",(long)self.tweet.retweetNum]];
    
    [[TwitterClient sharedInstance] retweet:self.tweet.idStr];
}

- (void) favoriteFlagTaped {
    if(self.tweet.favorited) {
        self.favoratedFlagImage.image = [UIImage imageNamed:@"favorite"];
        self.tweet.favorateNum--;
    } else {
        self.favoratedFlagImage.image = [UIImage imageNamed:@"favorite_on"];
        self.tweet.favorateNum++;
    }
    
    self.tweet.favorited = !self.tweet.favorited;
    
    [self.favorateNumLabel setText:[NSString stringWithFormat:@"%ld",(long)self.tweet.favorateNum]];
    
    [[TwitterClient sharedInstance] retweet:self.tweet.idStr];
}



@end
