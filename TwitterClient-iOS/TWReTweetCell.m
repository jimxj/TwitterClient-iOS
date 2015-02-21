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
    self.testImage.layer.cornerRadius = 3;
    self.testImage.clipsToBounds = YES;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

-(void) setTweet:(TWTweet *)tweet {
    _tweet = tweet;
    
    [self.tweetTextLabel setText:tweet.text];
    [self.timestampLabel setText:[tweet.createdAt dateTimeAgo]];
    [self.replyNumLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.replyNum]];
    [self.retweetNumLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.retweetNum]];
    [self.favorateNumLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.favorateNum]];
    [self.userNameLabel setText:tweet.user.name];
    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", tweet.user.screenName]];
    [self.testImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
    
    if(tweet.retweeted) {
        self.retweetedFlagImage.image = [UIImage imageNamed:@"retweet_on"];
    } else {
        self.retweetedFlagImage.image = [UIImage imageNamed:@"retweet"];
        
        self.retweetHeaderImage.hidden = YES;
        self.retweetLabel.hidden = YES;
    }
    
    if(tweet.favorited) {
        self.favoratedFlagImage.image = [UIImage imageNamed:@"favorate_on"];
    } else {
        self.favoratedFlagImage.image = [UIImage imageNamed:@"favorate"];
    }
}




@end
