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

NSString * const kReTweetCellName = @"TWReTweetCell";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshController;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"Twitter";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"New" style:UIBarButtonItemStylePlain target:self action:@selector(onNewButton)];

    // set uptable view
    [self.tableView registerNib:[UINib nibWithNibName:kReTweetCellName bundle:nil] forCellReuseIdentifier:kReTweetCellName];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 85;

    self.refreshController = [[UIRefreshControl alloc] init];
    [self.refreshController addTarget:self action:@selector(refreshTimeLine) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshController atIndex:0];


    [self refreshTimeLine];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWReTweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kReTweetCellName];
    cell.tweet = self.tweets[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void) refreshTimeLine {
    [SVProgressHUD show];
    [[TwitterClient sharedInstance] GET:@"1.1/statuses/home_timeline.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"home_timeline json: %@", responseObject);
        //TWUser *user = [[TWUser alloc] initWithDictionary:responseObject error:nil];
        //NSLog(@"Current user : %@", user);
        
        self.tweets = [[TWTweet tweetsWithArray:responseObject] mutableCopy];
        
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
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
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
