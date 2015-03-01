//
//  UserProfileViewController.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/27/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TWUser.h"
#import "UIImageView+AFNetworking.h"
#import "TwitterClient.h"
#import "TWReTweetCell.h"

@interface UserProfileViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileBackgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCountLabel;

@property (weak, nonatomic) IBOutlet UITableView *userTimelineTableView;

@property (nonatomic, strong) NSArray *userTweets;

@end

@implementation UserProfileViewController

- (instancetype) initWithUserScreenName:(NSString *) screenName {
    self = [super init];
    if(self) {
        _screenName = screenName;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor blueColor].CGColor;
    
    [[TwitterClient sharedInstance] getUserInfo:self.screenName WithCompletion:^(NSDictionary *userDictionary, NSError *error) {
        [self.userNameLabel setText:[userDictionary valueForKey:@"name"]];
        [self.screenNameLabel setText:[NSString stringWithFormat:@"@%@",self.screenName]];
        [self.userProfileImage setImageWithURL:[NSURL URLWithString:[userDictionary valueForKey:@"profile_image_url"]]];
        [self.userProfileBackgroundImage setImageWithURL:[NSURL URLWithString:[userDictionary valueForKey:@"profile_background_image_url"]]];
        [self.tweetsCountLabel setText:[NSString stringWithFormat:@"%@",[userDictionary valueForKey:@"statuses_count"]]];
        [self.followingCountLabel setText:[NSString stringWithFormat:@"%@", [userDictionary valueForKey:@"friends_count"]]];
        [self.followerCountLabel setText:[NSString stringWithFormat:@"%@",[userDictionary valueForKey:@"followers_count"]]];
        
        [self.userNameLabel sizeToFit];
        [self.screenNameLabel sizeToFit];
        [self.tweetsCountLabel sizeToFit];
        [self.followingCountLabel sizeToFit];
        [self.followerCountLabel sizeToFit];
    }];
   
    // set uptable view
    self.userTimelineTableView.dataSource = self;
    self.userTimelineTableView.delegate = self;
    [self.userTimelineTableView registerNib:[UINib nibWithNibName:kTweetCellName bundle:nil] forCellReuseIdentifier:kTweetCellName];
    
    [[TwitterClient sharedInstance] getUserTimeline:self.screenName WithCompletion:^(NSArray *tweets, NSError *error) {
        self.userTweets = tweets;
        [self.userTimelineTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.userTweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWReTweetCell *cell = [self.userTimelineTableView dequeueReusableCellWithIdentifier:kTweetCellName];
    cell.tweet = self.userTweets[indexPath.row];
    //cell.tweetHandler = self;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
