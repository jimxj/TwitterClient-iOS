//
//  LeftViewController.m
//  TwitterClient-iOS
//
//  Created by Jim Liu on 2/26/15.
//  Copyright (c) 2015 Jim Liu. All rights reserved.
//

#import "LeftViewController.h"
#import "ProfileCell.h"

NSString * const kProfileCellName = @"ProfileCell";
NSString * const kTextCellName = @"TextCell";

@interface LeftViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) ProfileCell *profileCell;


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileCell" bundle:nil] forCellReuseIdentifier:kProfileCellName];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 64;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view deletages

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(indexPath.row == 0) {
//        return 64;
//    } else {
//        return 32;
//    }
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0: {
            ProfileCell *theProfileCell = [tableView dequeueReusableCellWithIdentifier:kProfileCellName];
            return theProfileCell;
        }
        case 1: {
            cell = [[UITableViewCell alloc] init];
            [cell.textLabel setText:@"Home Timeline"];
            break;
        }
        case 2: {
            cell = [[UITableViewCell alloc] init];
            [cell.textLabel setText:@"Mentions View"];
            break;
        }
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TwitterManuItem selectedItem;
    if(indexPath.row == 0) {
        selectedItem = TwitterManuItemUserProfile;
    } else if(indexPath.row == 1) {
        selectedItem = TwitterManuItemHomeTimeLine;
    } else if(indexPath.row == 2) {
        selectedItem = TwitterManuItemMentions;
    }
    
    [self.manuHandler manuDidChanged:selectedItem];
}

- (ProfileCell *) profileCell {
    if(!_profileCell) {
        _profileCell = [[ProfileCell alloc] init];
    }
    
    return _profileCell;
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
