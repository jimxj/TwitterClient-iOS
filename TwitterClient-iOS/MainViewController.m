//
//  MainViewController.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/19/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "MainViewController.h"
#import "TwitterClient.h"
#import "TWReTweetCell.h"
#import "TWTweet.h"
#import "TWTweetDetailViewController.h"
#import "SVProgressHUD.h"
#import "TWNewTweetViewController.h"
#import "TWNewTweetViewController.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "UserProfileViewController.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, NewTweetProtocol, TweetCellProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshController;
@property (nonatomic, strong) NSMutableArray *tweets;
//@property (nonatomic, assign) NSInteger maxId;
//@property (nonatomic, assign) NSInteger minId;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.borderWidth = 1;
    self.view.layer.borderColor = [UIColor blueColor].CGColor;
    
    self.title = @"Twitter";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];

    // set uptable view
    [self.tableView registerNib:[UINib nibWithNibName:kTweetCellName bundle:nil] forCellReuseIdentifier:kTweetCellName];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 85;

    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(refreshTimeLine) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshController atIndex:0];
    
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        // prepend data to dataSource, insert cells at top of table view
//        // call [tableView.pullToRefreshView stopAnimating] when done
//        [self refreshTimeLine];
//    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        // prepend data to dataSource, insert cells at top of table view
        // call [tableView.pullToRefreshView stopAnimating] when done
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *maxId = [f numberFromString:((TWTweet *)[self.tweets lastObject]).idStr];
        [self refreshTimeLineWithinMaxId:[NSNumber numberWithLong:maxId.longLongValue - 1] andMinId:nil];
    }];

    [self refreshTimeLineWithinMaxId:nil andMinId:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWReTweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTweetCellName];
    cell.tweet = self.tweets[indexPath.row];
    cell.tweetHandler = self;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void) refreshTimeLine {
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [self refreshTimeLineWithinMaxId:nil andMinId:[f numberFromString:((TWTweet *)[self.tweets firstObject]).idStr]];
}

- (void) refreshTimeLineWithinMaxId:(NSNumber *) maxId andMinId:(NSNumber *) minId {
    [SVProgressHUD show];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(maxId) {
        [params setObject:maxId forKey:@"max_id"];
    }
    if(minId) {
        [params setObject:minId forKey:@"since_id"];
    }
    [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"home_timeline json: %@", responseObject);
        //TWUser *user = [[TWUser alloc] initWithDictionary:responseObject error:nil];
        //NSLog(@"Current user : %@", user);
        
        NSArray *newTweets = [TWTweet tweetsWithArray:responseObject];
        if(maxId) { // add at tail
            [self.tweets addObjectsFromArray:newTweets];
        } else if(minId) { // add at beginning
            self.tweets = [[newTweets arrayByAddingObjectsFromArray:self.tweets] mutableCopy];
        } else {
            self.tweets = [[TWTweet tweetsWithArray:responseObject] mutableCopy];
        }
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        [self.refreshController endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Faile to get home_timeline : %@", error);
        [SVProgressHUD dismiss];
        [self.refreshController endRefreshing];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];

    TWTweetDetailViewController *detailsView = [[TWTweetDetailViewController alloc] init];
    detailsView.tweet =  self.tweets[indexPath.row];
    [self.navigationController pushViewController:detailsView animated:YES];
}

-(void) onSignOutButton {
    [TWUser logout];
}

-(void) onNewButton {
    TWNewTweetViewController *vc = [[TWNewTweetViewController alloc] init];
    vc.tweetCreationListner = self;
    //UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    //[self presentViewController:nvc animated:YES completion:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma new tweet protocol
- (void) newTweet:(TWTweet *) tweet {
    [self.tweets insertObject:tweet atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
    //[self.tableView reloadData];
}

#pragma mark - TweetCellProtocol
- (void) tweetCell:(TWReTweetCell *) tweetCell userImageDidTapped:(NSString *) screenName {
    UserProfileViewController *vc = [[UserProfileViewController alloc] initWithUserScreenName:screenName];
    [self.navigationController pushViewController:vc animated:YES];
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
