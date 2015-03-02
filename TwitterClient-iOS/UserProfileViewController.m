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
#import "UserProfileCell.h"

CGFloat const kHeaderHeight = 112;

@interface UserProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userProfileBackgroundImage;

@property (weak, nonatomic) IBOutlet UITableView *userTimelineTableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (nonatomic, strong) NSArray *userTweets;

@property (nonatomic, strong) NSDictionary *userInfo;

@end

@implementation UserProfileViewController

- (instancetype) initWithUserScreenName:(NSString *) screenName hasNavigationbar:(BOOL) hasNavigationBar {
    self = [super init];
    if(self) {
        _screenName = screenName;
        _hasNavigationBar = hasNavigationBar;
        
        [[TwitterClient sharedInstance] getUserInfo:self.screenName WithCompletion:^(NSDictionary *userDictionary, NSError *error) {
            self.userInfo = userDictionary;
            [self.userTimelineTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:NO];
            [self.userProfileBackgroundImage setImageWithURL:[NSURL URLWithString:[userDictionary valueForKey:@"profile_background_image_url"]]];
            
        }];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor blueColor].CGColor;
    
    // set uptable view
    self.userTimelineTableView.dataSource = self;
    self.userTimelineTableView.delegate = self;
    self.userTimelineTableView.rowHeight = UITableViewAutomaticDimension;
    self.userTimelineTableView.estimatedRowHeight = 85;
    [self.userTimelineTableView registerNib:[UINib nibWithNibName:kTweetCellName bundle:nil] forCellReuseIdentifier:kTweetCellName];
    [self.userTimelineTableView registerNib:[UINib nibWithNibName:kUserProfileCellName bundle:nil] forCellReuseIdentifier:kUserProfileCellName];
    
    [[TwitterClient sharedInstance] getUserTimeline:self.screenName WithCompletion:^(NSArray *tweets, NSError *error) {
        self.userTweets = tweets;
        [self.userTimelineTableView reloadData];
    }];
    
    if(self.hasNavigationBar) {
        self.navigationController.navigationBar.translucent = YES;
        self.tabBarController.tabBar.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self.view addGestureRecognizer:tapGesture];
    }
    
    //self.userTimelineTableView.tableHeaderView = nil;
    //[self.userTimelineTableView addSubview:self.headerView];
//
//    self.userTimelineTableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
//    self.userTimelineTableView.contentOffset = CGPointMake(0, -kHeaderHeight);
//    [self udpateHeaderView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
        case 1:
            return self.userTweets.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UserProfileCell *cell = [self.userTimelineTableView dequeueReusableCellWithIdentifier:kUserProfileCellName];
            cell.userInfoDictionary = self.userInfo;
            return cell;
        }
        case 1: {
            TWReTweetCell *cell = [self.userTimelineTableView dequeueReusableCellWithIdentifier:kTweetCellName];
            cell.tweet = self.userTweets[indexPath.row];
            //cell.tweetHandler = self;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            return cell;
        }
        default:
            return nil;
    }
}

- (IBAction)onTap:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
    }];
}

- (void) udpateHeaderView {
//    CGRect headerRect = CGRectMake(0, -kHeaderHeight, self.userTimelineTableView.bounds.size.width, kHeaderHeight);
//    if(self.userTimelineTableView.contentOffset.y < -kHeaderHeight) {
//        headerRect.origin.y = self.userTimelineTableView.contentOffset.y;
//        headerRect.size.height = - self.userTimelineTableView.contentOffset.y;
//    }
//    
//    self.headerView.frame = headerRect;
}

#pragma mark - scroll view

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    [self udpateHeaderView];
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
