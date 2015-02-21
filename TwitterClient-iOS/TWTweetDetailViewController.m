//
//  TWTweetDetailViewController.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/21/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "TWTweetDetailViewController.h"
#import "NSDate+TimeAgo.h"
#import "UIImageView+AFNetworking.h"

@interface TWTweetDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *retweetImage1;
@property (weak, nonatomic) IBOutlet UILabel *retweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *favorateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;

@end

@implementation TWTweetDetailViewController

-(instancetype) initWithTweet:(TWTweet *) tweet {
    self = [super init];
    if(self) {
        _tweet = tweet;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tweetTextLabel setText:self.tweet.text];
    [self.timestampLabel setText:[self.tweet.createdAt dateTimeAgo]];
    [self.retweetNumLabel setText:[NSString stringWithFormat:@"%ld",(long)self.tweet.retweetNum]];
    [self.favorateLabel setText:[NSString stringWithFormat:@"%ld",(long)self.tweet.favorateNum]];
    [self.userNameLabel setText:self.tweet.user.name];
    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", self.tweet.user.screenName]];
    [self.userProfileImage setImageWithURL:[NSURL URLWithString:self.tweet.user.profileImageUrl]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void) setTweet:(TWTweet *)tweet {
//    _tweet = tweet;
//    
//    NSLog(@"---tweet for detail : %@", tweet);
//    
//    [self.tweetTextLabel setText:tweet.text];
//    [self.timestampLabel setText:[tweet.createdAt dateTimeAgo]];
//    [self.retweetNumLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.retweetNum]];
//    [self.favorateLabel setText:[NSString stringWithFormat:@"%ld",(long)tweet.favorateNum]];
//    [self.userNameLabel setText:tweet.user.name];
//    [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@", tweet.user.screenName]];
//    [self.userProfileImage setImageWithURL:[NSURL URLWithString:tweet.user.profileImageUrl]];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
